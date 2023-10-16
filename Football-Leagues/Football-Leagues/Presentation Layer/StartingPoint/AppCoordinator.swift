//
//  AppCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import UIKit

protocol Coordinating{
    func start()
}

class AppCoordinator:Coordinating{
    private var window:UIWindow!
    private var nav:UINavigationController!
    init(window: UIWindow!) {
        self.window = window
    }
    func start() {
        let vc = LeaguesViewController()
        self.nav = UINavigationController(rootViewController: vc)
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
