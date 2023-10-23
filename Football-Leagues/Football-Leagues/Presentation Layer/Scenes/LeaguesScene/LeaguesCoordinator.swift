//
//  LeaguesCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import UIKit
protocol LeaguesCoordinatorProtocol:AnyCoordinator{
    func navigateToDetails(withData:String)
}
struct LeaguesCoordinator:LeaguesCoordinatorProtocol{    
    var navigationController: UINavigationController?
    
    func start() {
        guard let navigationController = navigationController else {return}
        let vc = LeaguesViewController()
        let viewModel = LeaguesViewModel(coordinator: self)
        vc.viewModel = viewModel
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    func navigateToDetails(withData data: String) {
        guard let navigationController = navigationController else {return}
        let coordinator = LeagueDetailsCoordinator(navigationController: navigationController,data: data)
        coordinator.start()
    }
}
