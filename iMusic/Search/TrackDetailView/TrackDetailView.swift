

import UIKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimerSlider(_ sender: UISlider) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
    }
    
    @IBAction func previousTrackButton(_ sender: UIButton) {
    }
    
    @IBAction func nextTrackButton(_ sender: UIButton) {
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
    }
    
    
}
