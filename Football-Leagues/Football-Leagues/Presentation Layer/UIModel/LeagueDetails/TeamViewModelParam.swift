//
//  TeamViewModelParam.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

struct TeamViewModelParam {
    let coordinator: TeamCoordinator
    let usecase: TeamUsecaseProtcol = TeamUsecase()
    let team: LeagueDetailsViewDataModel
}
