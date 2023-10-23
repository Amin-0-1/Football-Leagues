//
//  LeaguesViewModelParams.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import Foundation

struct LeaguesViewModelParams{
    let usecase: LeagueDetailsUsecaseProtocol = LeagueDetailsUsecase()
    let coordinator: LeagueDetailsCoordinatorProtocol
    let code:String
}
