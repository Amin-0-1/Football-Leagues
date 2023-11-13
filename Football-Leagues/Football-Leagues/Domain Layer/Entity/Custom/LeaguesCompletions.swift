//
//  LeaguesCompletions.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

typealias LeaguesCompletion = (Result<LeagueDataModel, CustomDomainError>) -> Void
typealias SeasonsCompletion = (Result<SeasonDataModel, CustomDomainError>) -> Void
typealias SeamsCompletion = (Result<TeamsDataModel, CustomDomainError>) -> Void
typealias MatchesCompletion = (Result<MatchesDataModel, CustomDomainError>) -> Void
typealias Completion = () -> Void

struct LeaguesCompletions {
    let leaguesCompletion: leaguesCompletion
    let seasonsCompletion: seasonsCompletion
    let teamsCompletion: teamsCompletion
    let matchesCompletion: matchesCompletion
    let completion: completion
}
