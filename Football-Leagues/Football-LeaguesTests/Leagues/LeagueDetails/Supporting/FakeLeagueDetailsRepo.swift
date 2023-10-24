//
//  FakeLeagueDetailsRepo.swift
//  Football-LeaguesTests
//
//  Created by Amin on 22/10/2023.
//

import Combine
import Foundation
@testable import Football_Leagues

class FakeLeagueDetailsRepo:LeagueDetailsRepositoryInteface{

    
    
    let localShouldFail:Bool
    let remoteShouldFail:Bool
    let fetchTeamsShouldFail:Bool
    
    var isSuccessLocalVisited:Bool = false
    var isSuccessRemoteVisited:Bool = false
    var isSuccessSaveVisted:Bool = false
    
    var error = "FakeLeagueDetailsRepo.error"
    var checkTeamCount = 0
    
    init(localShouldFail: Bool = false, remoteShouldFail: Bool = false, fetchTeamsShouldFail: Bool = false) {
        self.localShouldFail = localShouldFail
        self.remoteShouldFail = remoteShouldFail
        self.fetchTeamsShouldFail = fetchTeamsShouldFail

    }
    
    func fetchLocalTeams(localEndPoint: Football_Leagues.LocalEndPoint) -> Future<Football_Leagues.LeagueDetailsDataModel, Error> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            if !self.localShouldFail{
                guard let fakeModel = FakeJsonDecoder().getModelFrom(jsonFile: "StubLeagueDetails", decodeType: LeagueDetailsDataModel.self) else {
                    promise(.failure(CustomDomainError.customError("Failed to decode in testing")))
                    return
                }
                self.isSuccessLocalVisited = true
                self.checkTeamCount =  fakeModel.count ?? 0
                promise(.success(fakeModel))
            }else{
                promise(.failure(CustomDomainError.customError(self.error)))
            }
        }
    }
    
    func fetchRemoteTeams(remoteEndPoint: Football_Leagues.EndPoint) -> Future<Football_Leagues.LeagueDetailsDataModel, Error> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            if !self.remoteShouldFail{
                guard let fakeModel = FakeJsonDecoder().getModelFrom(jsonFile: "StubLeagueDetails", decodeType: LeagueDetailsDataModel.self) else {
                    promise(.failure(CustomDomainError.customError("Failed to decode in testing")))
                    return
                }
                self.isSuccessRemoteVisited = true
                self.checkTeamCount =  fakeModel.count ?? 0
                promise(.success(fakeModel))
            }else{
                promise(.failure(CustomDomainError.customError(self.error)))
            }
        }
    }
    
    func saveTeam(model: Football_Leagues.LeagueDetailsDataModel, localEndPoint: Football_Leagues.LocalEndPoint) -> Future<Bool, Error> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            if !fetchTeamsShouldFail{
                isSuccessSaveVisted = true
                promise(.success(true))
            }else{
                promise(.failure(CustomDomainError.serverError))
            }
        }
    }
}

