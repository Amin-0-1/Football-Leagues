//
//  FakeLeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

@testable import Football_Leagues
class FakeLeaguesRepository:LeaguesRepoInterface{
    
    
   
    var shouldFail:Bool
    init(shouldFailed: Bool) {
        self.shouldFail = shouldFailed
    }
    
    var isSaveVisited = false
    let error:String = "mock error"
    let competitionCounts = 2    // count of competition in json files
    func fetchLeagues(endPoint: EndPoint) -> Future<LeaguesDataModel, CustomDomainError> {
        return Future<LeaguesDataModel,CustomDomainError>{ promise in
            if !self.shouldFail{
                guard let fakeModel = FakeJsonDecoder().getModelFrom(jsonFile: "StubLeague", decodeType: LeaguesDataModel.self) else {
                    promise(.failure(.customError("Failed to decode in testing")))
                    return
                }
                promise(.success(fakeModel))
            }else{
                promise(.failure(.customError(self.error)))
            }
        }
    }
    
    func save<T>(leagues: T, localEntityType: Football_Leagues.LocalEndPoint) -> Future<Bool, Error>  {
        isSaveVisited = true
        return Future<Bool,Error>{ promise in
            promise(.failure(NSError(domain: self.error, code: 0)))
        }
    }

}


