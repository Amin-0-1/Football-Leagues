//
//  StaffCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import UIKit

struct StaffCoordinator: AnyCoordinator {
    var navigationController: UINavigationController?
    
    func start() {
        let vc = StaffVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
