//
//  LeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol LeaguesRepoInterface{
    func fetchLocalLeagues(localEntityType:LocalEndPoint) ->Future<LeaguesDataModel,Error>
    func fetchRemoteLeagues(endpoint:EndPoint)-> Future<LeaguesDataModel,Error>
    func saveLeagues(leagues:LeaguesDataModel,localEntity:LocalEndPoint) ->Future<Bool,Error>
}
struct LeaguesReposiotory:LeaguesRepoInterface{

    private let appRepo:RepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: RepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
    
    func fetchLocalLeagues(localEntityType: LocalEndPoint) -> Future<LeaguesDataModel, Error> {
        return appRepo.fetch(endPoint: nil, localEntity: localEntityType)
    }
    
    func fetchRemoteLeagues(endpoint: EndPoint) -> Future<LeaguesDataModel, Error> {
        return self.appRepo.fetch(endPoint: endpoint, localEntity: nil)
    }
    
    
    func saveLeagues(leagues: LeaguesDataModel,localEntity:LocalEndPoint) -> Future<Bool, Error> {
        return self.appRepo.save(data: leagues, localEntity: localEntity)
    }
    
}
