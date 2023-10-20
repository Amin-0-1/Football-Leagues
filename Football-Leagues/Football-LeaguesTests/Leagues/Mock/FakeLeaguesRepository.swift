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
   
    var shouldFailed:Bool
    init(shouldFailed: Bool) {
        self.shouldFailed = shouldFailed
    }
    
    var isSaveVisited = false
    let error:String = "fake fetch failed"
    let competitionCounts = 2    // count of competition in json files
    func fetchLeagues(endPoint: EndPoint) -> Future<LeagueDataModel, CustomDomainError> {
        return Future<LeagueDataModel,CustomDomainError>{ promise in
            if !self.shouldFailed{
                guard let fakeModel = FakeJsonDecoder().getModelFrom(jsonFile: "SubLeagueModel", decodeType: LeagueDataModel.self) else {
                    print("failed to decode stub json")
                    return
                }
                promise(.success(fakeModel))
            }else{
                promise(.failure(.customError(self.error)))
            }
        }
    }
    func save<T>(leagues: T) -> Future<Bool, Error> where T : Decodable, T : Encodable {
        isSaveVisited = true
        return Future<Bool,Error>{ primse in
            primse(.success(true))
        }
    }
}


