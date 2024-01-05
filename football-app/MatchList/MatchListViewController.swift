//
//  MatchListViewController.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import UIKit
import Combine

class MatchListViewController: UIViewController {

    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        let service = MatchService()
        
        service.fetchMatches().sink { completion in
            // Handle completion
        } receiveValue: { matchList in
            print(matchList)
        }
        .store(in: &cancellables)
    }
}
