//
//  TeamsCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit

protocol GamesCoordinatorProtocol:AnyCoordinator{
    
}
struct GamesCoordinator:GamesCoordinatorProtocol{
    var navigationController: UINavigationController
    var team:LeagueDetailsViewDataModel
    func start() {
        let vc = GamesViewController()
        let params = TeamViewModelParam(coordinator: self, team: team)
        let viewModel = GamesViewModel(param: params)
        vc.viewModl = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
