//
//  FakeLeaguesUsecase.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import Foundation
import Combine
@testable import Football_Leagues


class FakeLeaguesUsecase:LeaguesUsecaseProtocol{
    var shouldFail:Bool
    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    var error = "FakeLeaguesUsecase.error"
    var leagueCount:Int = 0
    
    func fetchLeagues() -> Future<LeagueDataModel, CustomDomainError> {
        return Future<LeagueDataModel,CustomDomainError>{ promise in
            if !self.shouldFail{
                guard let fakeModel = FakeJsonDecoder().getModelFrom(jsonFile: "StubLeague", decodeType: LeagueDataModel.self) else {
                    promise(.failure(.customError("Failed to decode in testing")))
                    return
                }
                self.leagueCount = fakeModel.count ?? 0 
                promise(.success(fakeModel))
            }else{
                promise(.failure(.customError(self.error)))
            }
        }
            
    }
}
