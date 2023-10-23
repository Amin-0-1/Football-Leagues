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
    func fetchRemoteGames(endpoint:EndPoint)-> Future<TeamDataModel,Error>
    func saveGames(model:TeamDataModel,localEntityType:LocalEndPoint)->Future<Bool,Error>
    
}
class TeamRepository:TeamRepositoryProtocol{
    
    private let appRepo:RepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: RepositoryInterface = AppRepository(),
         connectivity: ConnectivityProtocol = ConnectivityService()) {
        self.appRepo = appRepo
    }
    
    func fetchLocalGames(localEndpoint: LocalEndPoint) -> Future<TeamDataModel, Error> {
        return self.appRepo.fetch(endPoint: nil, localEntity: localEndpoint)
    }
    
    
    func fetchRemoteGames(endpoint: EndPoint) -> Future<TeamDataModel, Error> {
        return self.appRepo.fetch(endPoint: endpoint, localEntity: nil)
    }
    
    func saveGames(model: TeamDataModel, localEntityType: LocalEndPoint) -> Future<Bool, Error> {
        return appRepo.save(data: model, localEntity: localEntityType)
    }
}

