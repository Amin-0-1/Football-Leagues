//
//  FakeTeamDetialsRepo.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import Foundation
import Combine

import Football_Leagues
class FakeTeamDetailsRepo: TeamRepositoryProtocol {

    let shouldFail: Bool
    var isVisited = false
    var error = ""
    var checkNumberOFWins = 0
    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }

    func save(model: TeamDataModel, localEntityType: LocalEndPoint) -> Future<Bool, Error> {
        isVisited = true
        return Future<Bool, Error> { promise in
            promise(.failure(NSError(domain: self.error, code: 0)))
        }
    }
    func fetchLocalGames(localEndpoint: Football_Leagues.LocalEndPoint) -> Future<Football_Leagues.TeamDataModel, Error> {
        return .init { promise in
            if !self.shouldFail {
                guard let decoded = FakeJsonDecoder()
                    .getModelFrom(jsonFile: "StubTeamDetails", decodeType: TeamDataModel.self) else {
                    promise(.failure(CoreDataManager.Errors.decodingFailed))
                    return
                }
                
                promise(.success(decoded))
            } else {
                let custom = CustomDomainError.connectionError
                self.error = custom.localizedDescription
                promise(.failure(custom))
            }
        }
    }
    
    func fetchRemoteGames(remoteEndPoint: Football_Leagues.EndPoint) -> Future<Football_Leagues.TeamDataModel, Error> {
        return .init { promise in
            if !self.shouldFail {
                guard let decoded = FakeJsonDecoder()
                    .getModelFrom(jsonFile: "StubTeamDetails", decodeType: TeamDataModel.self) else {
                    promise(.failure(CoreDataManager.Errors.decodingFailed))
                    return
                }
                promise(.success(decoded))
            } else {
                let custom = CustomDomainError.connectionError
                self.error = custom.localizedDescription
                promise(.failure(custom))
            }
        }
    }
    
    func saveGames(model: Football_Leagues.TeamDataModel, localEndPoint: Football_Leagues.LocalEndPoint) -> Future<Bool, Error> {
        isVisited = true
        return .init { promise in
            promise(.failure())
        }
    }
}
