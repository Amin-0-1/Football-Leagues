//
//  LeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol LeaguesRepoInterface{
    func fetchLeagues(endPoint:EndPoint,completion:@escaping (Result<LeagueDataModel,NetworkError>)->Void)
    func fetchSeasons(endPoint:EndPoint,completion:@escaping (Result<SeasonDataModel,NetworkError>)->Void)
    func fetchTeams(endPoint:EndPoint,completion:@escaping(Result<TeamsDataModel,NetworkError>)->Void)
    func fetchMatches(endPoint:EndPoint,completion:@escaping(Result<MatchesDataModel,NetworkError>)->Void)
}
class LeaguesReposiotory:LeaguesRepoInterface{
    
    private let appRepo:RepositoryInterface!
    
    init(appRepo: RepositoryInterface!) {
        self.appRepo = appRepo
    }

    func fetchLeagues(endPoint: EndPoint, completion: @escaping (Result<LeagueDataModel, NetworkError>) -> Void) {
        appRepo.fetch(endPoint: endPoint, completion: completion)
    }
    
    func fetchSeasons(endPoint: EndPoint, completion: @escaping (Result<SeasonDataModel, NetworkError>) -> Void) {
        appRepo.fetch(endPoint: endPoint, completion: completion)
    }
    
    func fetchTeams(endPoint: EndPoint, completion: @escaping (Result<TeamsDataModel, NetworkError>) -> Void) {
        appRepo.fetch(endPoint: endPoint, completion: completion)
    }
    
    func fetchMatches(endPoint: EndPoint, completion: @escaping (Result<MatchesDataModel, NetworkError>) -> Void) {
        appRepo.fetch(endPoint: endPoint, completion: completion)
    }
}
