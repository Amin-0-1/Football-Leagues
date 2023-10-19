//
//  AppCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

struct AppCoordinator:Coordinator{
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let leagueCoordinator = LeaguesCoordinator(navigationController: navigationController)
        leagueCoordinator.start()
    }
}
