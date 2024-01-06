//
//  MatchListTabViewController.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import UIKit

class MatchListTabViewController: UITabBarController {
    lazy var previousMatchVC: MatchListViewController = {
        let vc = MatchListViewController()
        vc.viewModel = MatchListViewModel(matchPhase: .previous)
        vc.tabBarItem = UITabBarItem(
            title: "Previous",
            image: UIImage(systemName: "clock.arrow.circlepath"),
            selectedImage: nil
        )
        return vc
    }()
    
    lazy var upcomingMatchVC: MatchListViewController = {
        let vc = MatchListViewController()
        vc.viewModel = MatchListViewModel(matchPhase: .upcoming)
        vc.tabBarItem = UITabBarItem(
            title: "Upcoming",
            image: UIImage(systemName: "calendar"),
            selectedImage: nil
        )
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup

private extension MatchListTabViewController {
    func setup() {
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        viewControllers = [
            UINavigationController(rootViewController: previousMatchVC),
            UINavigationController(rootViewController: upcomingMatchVC) 
        ]
    }
}
