//
//  LeaguesCompletions.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

typealias leaguesCompletion = (Result<LeagueDataModel,CustomDomainError>)->Void
typealias seasonsCompletion = (Result<SeasonDataModel,CustomDomainError>)->Void
typealias teamsCompletion = (Result<TeamsDataModel,CustomDomainError>)->Void
typealias matchesCompletion = (Result<MatchesDataModel,CustomDomainError>)->Void
typealias completion = ()->Void
struct LeaguesCompletions{
    let leaguesCompletion: leaguesCompletion
    let seasonsCompletion: seasonsCompletion
    let teamsCompletion: teamsCompletion
    let matchesCompletion: matchesCompletion
    let completion: completion
}
