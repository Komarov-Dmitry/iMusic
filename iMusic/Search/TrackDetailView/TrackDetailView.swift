

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    
    func moveBackForTrack() -> SearchViewModel.Cell?
    func moveForwardForTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    @IBOutlet weak var miniTrackView: UIView!
    
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    @IBOutlet weak var maxizedStackView: UIStackView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
// MARK: - awakeFromNib
    override  func awakeFromNib() {
        super.awakeFromNib()
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 8
        miniPlayPauseButton.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        setupGestures()
    }
    
    
    //MARK: - Setup
    
    func set(viewModel:SearchViewModel.Cell) {
        miniTrackTitleLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observedPlayerCurrentTime()
        playPauseButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func setupGestures() {
        
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {

        case .began:
            print("began")
            
        case .changed:
            handlePanChanged(gesture: gesture)
            
        case .ended:
            handlePanEnded(gesture: gesture)

        @unknown default:
            print("@unknown")
        }
    }
    

    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if translation.y < -200 || velocity.y < -500 || translation.y > 10 {
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
                self.transform = .identity
            } else {
                self.tabBarDelegate?.minimizeTrackDetailController()
                self.transform = .identity
                self.miniTrackView.alpha = 1
                self.maxizedStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maxizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
                self.maxizedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                }
            }, completion: nil)

        @unknown default:
            print("unknown default")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maxizedStackView.alpha = -translation.y / 200
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    //MARK: - @Time Setup

    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackView()
        }
    }
    
    private func observedPlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationTimeText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationTimeText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    //MARK: - @Animations
    
    private func enlargeTrackView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    //MARK: - @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.tabBarDelegate?.minimizeTrackDetailController()
        //self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimerSlider(_ sender: UISlider) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func previousTrackButton(_ sender: UIButton) {
        let cellViewModel = delegate?.moveBackForTrack()
        guard let cellInfo = cellViewModel else { return }
        self.set(viewModel: cellInfo)
    }
    
    @IBAction func nextTrackButton(_ sender: UIButton) {
        let cellViewModel = delegate?.moveForwardForTrack()
        guard let cellInfo = cellViewModel else { return }
        self.set(viewModel: cellInfo)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
            enlargeTrackView()
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(imageLiteralResourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(imageLiteralResourceName: "play"), for: .normal)
            reduceTrackView()
        }
    }
    
    
}
