

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
    
}

class MainTabBarController : UITabBarController {
    
    
    private var minTopAnchorConstraint: NSLayoutConstraint!
    private var maxTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryBoard()

    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self
        
        var libary = Libary()
        libary.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: libary)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "library")
        hostVC.tabBarItem.title = "Libary"
        
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search"),
            hostVC
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    
    
    private func setupTrackDetailView() {
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maxTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
        minTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        maxTopAnchorConstraint.isActive = true
        
        //        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        
        
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minTopAnchorConstraint.isActive = false
        maxTopAnchorConstraint.isActive = true
        maxTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maxizedStackView.alpha = 1
        },
                       completion: nil)
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    
    func minimizeTrackDetailController() {
        
        maxTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maxizedStackView.alpha = 0
        },
                       completion: nil)
    }
    
    
}
