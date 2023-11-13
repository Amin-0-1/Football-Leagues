//
//  FakeLeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

import Football_Leagues
class FakeLeaguesRepository: LeaguesRepoInterface {
       
    var shouldFailLocal: Bool
    var shouldFailRemote: Bool
    var shouldFailSave: Bool
    var isLocalSuccessVisited = false
    var isRemoteSuccessVisited = false
    var isSavedVisited = false
    var modelCount = 0
    var error = "FakeLeaguesRepository.error"
    
    init(shouldFailLocal: Bool = false, shouldFailRemote: Bool = false, shouldFailSave: Bool = false) {
        self.shouldFailLocal = shouldFailLocal
        self.shouldFailRemote = shouldFailRemote
        self.shouldFailSave = shouldFailSave
    }

    func fetchLocalLeagues(localEndPoint: Football_Leagues.LocalEndPoint) -> Future<Football_Leagues.LeaguesDataModel, Error> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            if self.shouldFailLocal {
                promise(.failure(CustomDomainError.connectionError))
            } else {
                guard let fakeModel = FakeJsonDecoder()
                    .getModelFrom(jsonFile: "StubLeague", decodeType: LeaguesDataModel.self) else {
                    promise(.failure(CustomDomainError.serverError))
                    return
                }
                isLocalSuccessVisited = true
                self.modelCount = fakeModel.count ?? 0
                promise(.success(fakeModel))
            }
        }
    }
    
    func fetchRemoteLeagues(remoteEndPoint: Football_Leagues.EndPoint) -> Future<Football_Leagues.LeaguesDataModel, Error> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            if self.shouldFailRemote {
                promise(.failure(CustomDomainError.connectionError))
            } else {
                guard let fakeModel = FakeJsonDecoder()
                    .getModelFrom(jsonFile: "StubLeague", decodeType: LeaguesDataModel.self) else {
                    promise(.failure(CustomDomainError.serverError))
                    return
                }
                isRemoteSuccessVisited = true
                self.modelCount = fakeModel.count ?? 0
                promise(.success(fakeModel))
            }
        }
    }
    
    func saveLeagues(leagues: Football_Leagues.LeaguesDataModel, localEndPoint: Football_Leagues.LocalEndPoint) -> Future<Bool, Error> {
        isSavedVisited = true
        return .init { [weak self] promise in
            guard let self = self else {return}
            if !shouldFailSave {
                isSavedVisited = true
                promise(.success(true))
            } else {
                isSavedVisited = false
                promise(.failure(CustomDomainError.serverError))
            }
        }
    }
}
