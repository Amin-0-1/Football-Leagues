//
//  AppCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import UIKit

fileprivate protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol Coordinating{
    func navigate(step:AppCoordinator.Step)
}

class AppCoordinator:Coordinator{
    var navigationController: UINavigationController
    
    enum Step{
        case leage
        case leagueDetails
        case teams
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let vc = LeaguesViewController()
        let usecase = LeaguesUsecase()
        let viewModel = LeaguesViewModel(usecase: usecase)
        vc.viewModel = viewModel
        vc.coordinator = self
        self.navigationController.setViewControllers([vc], animated: false)
    }
}

extension AppCoordinator:Coordinating{
    func navigate(step: Step) {
        switch step {
            case .leagueDetails:
                let vc = LeaguesDetailsView()
                vc.coordinator = self
                navigationController.pushViewController(vc, animated: true)
            default:
                break
        }
    }
}
