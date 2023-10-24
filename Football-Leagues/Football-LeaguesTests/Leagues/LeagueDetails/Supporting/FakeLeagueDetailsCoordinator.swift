//
//  FakeCoordinator.swift
//  Football-LeaguesTests
//
//  Created by Amin on 24/10/2023.
//

import Foundation
@testable import Football_Leagues
class FakeLeagueDetailsCoordinator:LeagueDetailsCoordinatorProtocol{
    
    var onSuccessNavigation : ()->Void = {}
    init(onSuccessNavigation: @escaping () -> Void = {}) {
        self.onSuccessNavigation = onSuccessNavigation
    }
    
    func navigateToWebView(withLink: URL) {
            onSuccessNavigation()
    }
    
    func navigateTo(team: Football_Leagues.LeagueDetailsViewDataModel) {
        onSuccessNavigation()
    }
}
