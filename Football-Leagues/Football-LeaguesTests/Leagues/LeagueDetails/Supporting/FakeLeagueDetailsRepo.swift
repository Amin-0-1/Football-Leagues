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
    let shouldFail:Bool
    var isVisited:Bool = false
    var error = "mock error"
    var checkTeamCount = 0
    init(shouldFail: Bool){
        self.shouldFail = shouldFail
    }
    
    func fetchTeams(endPoint: EndPoint, localEntityType: LocalEndPoint) -> Future<LeagueDetailsDataModel, CustomDomainError> {
        return Future<LeagueDetailsDataModel,CustomDomainError>{ promise in
            if !self.shouldFail{
                guard let fakeModel = FakeJsonDecoder().getModelFrom(jsonFile: "StubLeagueDetails", decodeType: LeagueDetailsDataModel.self) else {
                    promise(.failure(.customError("Failed to decode in testing")))
                    return
                }
                self.checkTeamCount =  fakeModel.count ?? 0 
                promise(.success(fakeModel))
            }else{
                promise(.failure(.customError(self.error)))
            }

        }
    }
    
    func save(model: LeagueDetailsDataModel, localEntityType: LocalEndPoint) -> Future<Bool, Error> {
        self.isVisited = true
        return Future<Bool,Error>{ promise in
            promise(.failure(NSError(domain: self.error, code: 0)))
        }
    }
    
}
