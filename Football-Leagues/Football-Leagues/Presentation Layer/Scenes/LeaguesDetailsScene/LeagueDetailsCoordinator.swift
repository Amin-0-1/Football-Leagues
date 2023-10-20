//
//  LeagueDetailsCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import UIKit

protocol LeagueDetailsCoordinatorProtocol{
    
}

struct LeagueDetailsCoordinator:LeagueDetailsCoordinatorProtocol{
    
    var navigationController: UINavigationController
    func start() {
        let vc = LeagueDetailsViewController()
        let viewModel = LeagueDetailsViewModel(coordinator: self)
        vc.viewModel = viewModel
        self.navigationController.pushViewController(vc, animated: true)
    }
}
