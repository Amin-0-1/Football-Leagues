//
//  TeamViewModelParam.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

struct TeamViewModelParam{
    let coordinator: GamesCoordinator
    let usecase: GamesUsecaseProtocol = GamesUsecase()
    let team:LeagueDetailsViewDataModel
}
