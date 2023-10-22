//
//  AppCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import UIKit

protocol AnyCoordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

struct AppCoordinator:AnyCoordinator{
    var navigationController: UINavigationController

    func start() {
        let leagueCoordinator = LeaguesCoordinator(navigationController: navigationController)
        leagueCoordinator.start()
    }
}
