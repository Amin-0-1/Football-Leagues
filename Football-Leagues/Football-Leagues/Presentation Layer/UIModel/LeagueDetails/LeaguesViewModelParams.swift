//
//  LeaguesViewModelParams.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import Foundation

struct LeaguesViewModelParams {
    let usecase: LeagueDetailsUsecaseProtocol
    let coordinator: LeagueDetailsCoordinatorProtocol
    let code: String
    init(
        coordinator: LeagueDetailsCoordinatorProtocol,
        code: String,
        usecase: LeagueDetailsUsecaseProtocol = LeagueDetailsUsecase()
    ) {
        self.coordinator = coordinator
        self.code = code
        self.usecase = usecase
    }
}
