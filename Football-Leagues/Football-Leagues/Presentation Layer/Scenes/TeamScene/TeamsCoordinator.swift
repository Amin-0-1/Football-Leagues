//
//  TeamsCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit

protocol GamesCoordinatorProtocol: AnyCoordinator {
    func navigate(to: URL)
    func navigateToStaff(withID: Int)
}
struct TeamCoordinator: GamesCoordinatorProtocol {
    var navigationController: UINavigationController?
    var team: LeagueDetailsViewDataModel
    func start() {
        let params = TeamViewModelParam(coordinator: self, team: team)
        let viewModel = TeamViewModel(param: params)
        let vc = TeamDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    func navigate(to url: URL) {
        guard let navigationController = navigationController else {return}
        let vc = WebViewController()
        let coordinator = WebViewCoordinator(navigationController: navigationController, data: url)
        vc.coordinator = coordinator
        coordinator.start()
    }
    func navigateToStaff(withID id: Int) {
        let coordinator = StaffCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
