//
//  LeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol LeaguesRepoInterface{
    func fetch(endPoint:EndPoint,completion:@escaping (Result<LeagueDataModel,Error>)->Void)
}
class LeaguesReposiotory:LeaguesRepoInterface{
    
    private let appRepo:RepositoryInterface!
    
    init(appRepo: RepositoryInterface!) {
        self.appRepo = appRepo
    }

    func fetch(endPoint: EndPoint, completion: @escaping (Result<LeagueDataModel, Error>) -> Void) {
        appRepo.fetch(endPoint: endPoint, completion: completion)
    }
    
}
