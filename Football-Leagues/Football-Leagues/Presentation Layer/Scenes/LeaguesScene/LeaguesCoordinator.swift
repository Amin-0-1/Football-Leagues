//
//  LeaguesCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import UIKit
protocol LeaguesCoordinatorProtocol:Coordinator{
    func navigateToDetails(withData:String)
}
struct LeaguesCoordinator:LeaguesCoordinatorProtocol{    
    var navigationController: UINavigationController
    
    func start() {
        let vc = LeaguesViewController()
        let viewModel = LeaguesViewModel(coordinator: self)
        vc.viewModel = viewModel
        self.navigationController.setViewControllers([vc], animated: false)
    }
    func navigateToDetails(withData data: String) {
        let coordinator = LeagueDetailsCoordinator(navigationController: navigationController,data: data)
        coordinator.start()
    }
}
