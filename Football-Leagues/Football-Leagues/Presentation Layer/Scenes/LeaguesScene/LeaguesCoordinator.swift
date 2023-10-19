//
//  LeaguesCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import UIKit
protocol LeaguesCoordinatorProtocol:Coordinator{
    
}
struct LeaguesCoordinator:LeaguesCoordinatorProtocol{
    
    var navigationController: UINavigationController
    
    func start() {
        let vc = LeaguesViewController()
        let viewModel = LeaguesViewModel()
        vc.viewModel = viewModel
        vc.coordinator = self
        self.navigationController.setViewControllers([vc], animated: false)
    }
}
