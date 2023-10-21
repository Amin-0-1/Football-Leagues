//
//  LeagueDetailsCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import UIKit

protocol LeagueDetailsCoordinatorProtocol{
    func navigateToWebView(withLink : URL)
}

struct LeagueDetailsCoordinator:LeagueDetailsCoordinatorProtocol{
    
    var navigationController: UINavigationController
    private var data:String
    init(navigationController: UINavigationController,data:String) {
        self.navigationController = navigationController
        self.data = data
    }
    func start() {
        let vc = LeagueDetailsViewController()
        let viewModel = LeagueDetailsViewModel(params: .init(coordinator: self,code: data))
        vc.viewModel = viewModel
        self.navigationController.pushViewController(vc, animated: true)
    }
    func navigateToWebView(withLink url: URL) {
        let coordinator = WebViewCoordinator(navigationController: navigationController,data:url)
        coordinator.start()
        
    }
}
