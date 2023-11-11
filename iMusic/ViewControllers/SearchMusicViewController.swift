
import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchMusicViewController : UITableViewController {
    var networkService = NetworkService()
    
    private var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon")
        return cell
    }
    
    private func setUpSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTracks(searchText: searchText) {[weak self] (searchResults) in
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
            

        })
    }
}
