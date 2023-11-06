//
//  TrackCell.swift
//  iMusic
//
//  Created by Комаров Дмитрий  on 04.11.2023.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String? { get }

}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var trackArtistNameLabel: UILabel!
    
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        trackNameLabel.text = viewModel.trackName
        trackArtistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        trackImageView.layer.cornerRadius = 7

        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    
    @IBAction func addTrackAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: cell, requiringSecureCoding: false) {
            defaults.setValue(savedData, forKey: "tracks")
        }
        
    }
}
