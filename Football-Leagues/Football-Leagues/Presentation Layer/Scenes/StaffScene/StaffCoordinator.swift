//
//  StaffCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import UIKit

protocol StaffCoordinatorProtocol: AnyCoordinator {
    
}
struct StaffCoordinator: StaffCoordinatorProtocol {
    var navigationController: UINavigationController?
    private var data: Int
    init(navigationController: UINavigationController? = nil, withData data: Int) {
        self.navigationController = navigationController
        self.data = data
    }
    func start() {
        let viewModel = StaffViewModel(coordinator: self, teamID: data)
        let vc = StaffVC(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
