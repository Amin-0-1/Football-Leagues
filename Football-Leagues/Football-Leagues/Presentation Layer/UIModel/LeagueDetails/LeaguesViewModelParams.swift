//
//  LeaguesViewModelParams.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import Foundation

struct LeaguesViewModelParams{
    let input: LeagueDetailVMInputProtocol = LeagueDetailsVMInput()
    let output: LeagueDetailsVMOutputProtocol = LeagueDetailsVMOutput()
    let usecase: LeagueDetailsUsecaseProtocol = LeagueDetailsUsecase()
    let coordinator: LeagueDetailsCoordinatorProtocol
    let code:String
}
