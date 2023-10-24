//
//  FakeLeaguesCoordinator.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import UIKit
@testable import Football_Leagues


class FakeLeaguesCoordinator:LeaguesCoordinatorProtocol{

    var navigationController: UINavigationController?
    var onSuccessNavigation : ()->Void = {}
    
    init(onNavigation:@escaping()->Void = {}) {
        self.onSuccessNavigation = onNavigation
    }
    
    func start() {}
    
    
    func navigateToDetails(withData: String) {
        onSuccessNavigation()
    }
}
