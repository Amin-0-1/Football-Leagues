//
//  TeamsCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit

protocol SingleTeamCoordinatorProtocol:AnyCoordinator{
    
}
struct SingleTeamCoordinator:SingleTeamCoordinatorProtocol{
    var navigationController: UINavigationController
    
    func start() {
        let vc = SingleTeamVC()
        navigationController.pushViewController(vc, animated: true)
    }
}
