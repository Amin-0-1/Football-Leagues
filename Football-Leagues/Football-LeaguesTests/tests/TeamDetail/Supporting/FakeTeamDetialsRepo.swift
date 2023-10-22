//
//  FakeTeamDetialsRepo.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import Foundation
import Combine

@testable import Football_Leagues
class FakeTeamDetailsRepo:GamesRepositoryProtocol{
    
    let shouldFail:Bool
    var isVisited:Bool = false
    var error = "mock error"
    var checkNumberOFWins = 0
    init(shouldFail: Bool){
        self.shouldFail = shouldFail
    }
    
    
    func fetchGames(endPoint: EndPoint, localEntityType: LocalEntityType) -> Future<GamesDataModel, CustomDomainError> {
        return Future<GamesDataModel,CustomDomainError>{ promise in
            if !self.shouldFail{
                guard let decoded = FakeJsonDecoder().getModelFrom(jsonFile: "StubTeamDetails", decodeType: GamesDataModel.self) else{
                    promise(.failure(.customError("decoding error")))
                    return
                }
                self.checkNumberOFWins = decoded.resultSet?.wins ?? 0
                promise(.success(decoded))
            }else{
                promise(.failure(.customError(self.error)))
            }
        }
    }
    
    func save(model: GamesDataModel, localEntityType: LocalEntityType) -> Future<Bool, Error> {
        isVisited = true
        return Future<Bool,Error>{ promise in
            promise(.failure(NSError(domain: self.error, code: 0)))
        }
    }
    
}
