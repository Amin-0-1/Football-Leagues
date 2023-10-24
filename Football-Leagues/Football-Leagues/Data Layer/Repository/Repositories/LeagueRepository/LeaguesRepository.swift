//
//  LeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol LeaguesRepoInterface{
    func fetchLocalLeagues(localEndPoint:LocalEndPoint) ->Future<LeaguesDataModel,Error>
    func fetchRemoteLeagues(remoteEndPoint:EndPoint)-> Future<LeaguesDataModel,Error>
    func saveLeagues(leagues:LeaguesDataModel,localEndPoint:LocalEndPoint) ->Future<Bool,Error>
}
struct LeaguesReposiotory:LeaguesRepoInterface{

    private let appRepo:RepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: RepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
    
    func fetchLocalLeagues(localEndPoint: LocalEndPoint) -> Future<LeaguesDataModel, Error> {
        return appRepo.fetch(localEndPoint: localEndPoint)
    }
    
    func fetchRemoteLeagues(remoteEndPoint: EndPoint) -> Future<LeaguesDataModel, Error> {
        return self.appRepo.fetch(remoteEndPoint: remoteEndPoint)
    }
    
    
    func saveLeagues(leagues: LeaguesDataModel,localEndPoint:LocalEndPoint) -> Future<Bool, Error> {
        return self.appRepo.save(data: leagues, localEndPoint: localEndPoint)
    }
    
}
