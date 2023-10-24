//
//  AppCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import UIKit

protocol AnyCoordinator {
    var navigationController: UINavigationController? { get set }
    func start()
}

struct AppCoordinator:AnyCoordinator{
    var navigationController: UINavigationController?

    func start() {
        guard let navigationController = navigationController else {return}
        let launchScreen = LaunchScreenCoordinator(navigationController: navigationController)
        launchScreen.start()
    }
}
