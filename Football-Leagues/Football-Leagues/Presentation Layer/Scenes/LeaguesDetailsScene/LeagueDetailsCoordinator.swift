//
//  LeagueDetailsCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import UIKit

protocol LeagueDetailsCoordinatorProtocol {
    func navigateToWebView(withLink: URL)
    func navigateTo(team: LeagueDetailsViewDataModel)
}

struct LeagueDetailsCoordinator: LeagueDetailsCoordinatorProtocol {
    
    var navigationController: UINavigationController
    private var data: String
    init(navigationController: UINavigationController, data: String) {
        self.navigationController = navigationController
        self.data = data
    }
    func start() {
        let viewModel = LeagueDetailsViewModel(params: .init(coordinator: self, code: data))
        let vc = LeagueDetailsViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    func navigateToWebView(withLink url: URL) {
        let coordinator = WebViewCoordinator(navigationController: navigationController, data: url)
        coordinator.start()
    }
    func navigateTo(team: LeagueDetailsViewDataModel) {
        let coordinator = TeamCoordinator(navigationController: self.navigationController, team: team)
        coordinator.start()
    }
}
