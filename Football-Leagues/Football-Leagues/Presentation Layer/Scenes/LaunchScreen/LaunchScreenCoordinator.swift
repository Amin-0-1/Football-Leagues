//
//  LaunchScreenCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 23/10/2023.
//

import UIKit

protocol LaunchScreenCoordinatorProtocol:AnyCoordinator{
    func onFinishLoading()
}
class LaunchScreenCoordinator:LaunchScreenCoordinatorProtocol{
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let vc = LaunchScreen()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
    func onFinishLoading() {
        let leagueCoordinator = LeaguesCoordinator(navigationController: navigationController)
        leagueCoordinator.start()
    }
}
