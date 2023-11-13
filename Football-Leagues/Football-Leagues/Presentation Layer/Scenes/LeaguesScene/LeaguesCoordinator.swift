//
//  LeaguesCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import UIKit
protocol LeaguesCoordinatorProtocol: AnyCoordinator {
    func navigateToDetails(withData: String)
}
struct LeaguesCoordinator: LeaguesCoordinatorProtocol {
    var navigationController: UINavigationController?
    
    func start() {
        
        let viewModel = LeaguesViewModel(coordinator: self)
        let vc = LeaguesViewController(viewModel: viewModel)
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    func navigateToDetails(withData data: String) {
        guard let navigationController = navigationController else {return}
        let coordinator = LeagueDetailsCoordinator(navigationController: navigationController, data: data)
        coordinator.start()
    }
}
