//
//  SingleTeamRepository.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine

protocol TeamRepositoryProtocol{
    func fetchLocalGames(localEndpoint:LocalEndPoint)->Future<TeamDataModel,Error>
    func fetchRemoteGames(remoteEndPoint:EndPoint)-> Future<TeamDataModel,Error>
    func saveGames(model:TeamDataModel,localEndPoint:LocalEndPoint)->Future<TeamDataModel,Error>
    
}
class TeamRepository:TeamRepositoryProtocol{
    
    private let appRepo:RepositoryInterface
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: RepositoryInterface = AppRepository(),
         connectivity: ConnectivityProtocol = ConnectivityService()) {
        self.appRepo = appRepo
    }
    
    func fetchLocalGames(localEndpoint: LocalEndPoint) -> Future<TeamDataModel, Error> {
        return appRepo.fetch(localEndPoint: localEndpoint)
    }
    
    
    func fetchRemoteGames(remoteEndPoint: EndPoint) -> Future<TeamDataModel, Error> {
        return appRepo.fetch(remoteEndPoint: remoteEndPoint)
    }
    
    func saveGames(model: TeamDataModel, localEndPoint localEntityType: LocalEndPoint) -> Future<TeamDataModel, Error> {
        return appRepo.save(data: model, localEndPoint: localEntityType)
    }
}

