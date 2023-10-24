//
//  LeagueDetailsRepository.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsRepositoryInteface{
    func fetchLocalTeams(localEndPoint:LocalEndPoint) ->Future<LeagueDetailsDataModel,Error>
    func fetchRemoteTeams(remoteEndPoint:EndPoint)-> Future<LeagueDetailsDataModel,Error>
    func saveTeam(model:LeagueDetailsDataModel,localEndPoint:LocalEndPoint) ->Future<Bool,Error>
}
class LeagueDetailsRepository:LeagueDetailsRepositoryInteface{

    private var appRepo:RepositoryInterface
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: RepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }

    func fetchLocalTeams(localEndPoint: LocalEndPoint) -> Future<LeagueDetailsDataModel, Error> {
        return appRepo.fetch(localEndPoint: localEndPoint)
    }
    func fetchRemoteTeams(remoteEndPoint: EndPoint) -> Future<LeagueDetailsDataModel, Error> {
        return appRepo.fetch(remoteEndPoint: remoteEndPoint)
    }

    func saveTeam(model: LeagueDetailsDataModel, localEndPoint: LocalEndPoint) -> Future<Bool, Error> {
        return appRepo.save(data: model, localEndPoint: localEndPoint)
    }

}
