//
//  FakeLeaguesUsecase.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import Foundation
import Combine

@testable import Football_Leagues
class FakeLeaguesUsecase: LeaguesUsecaseProtocol {
    var shouldFail: Bool
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    var error = "FakeLeaguesUsecase.error"
    var isSuccessVisited = false
    var leagueCount: Int = 0
    
    func fetchLeagues() -> Future<LeaguesDataModel, CustomDomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            if !self.shouldFail {
                guard let fakeModel = FakeJsonDecoder()
                    .getModelFrom(jsonFile: "StubLeague", decodeType: LeaguesDataModel.self) else {
                    promise(.failure(.customError("Failed to decode in testing")))
                    return
                }
                self.isSuccessVisited = true
                self.leagueCount = fakeModel.count ?? 0
                promise(.success(fakeModel))
            } else {
                promise(.failure(.customError(self.error)))
            }
        }
    }
    func prepareForFakePublish(model: LeaguesDataModel) -> LeaguesViewDataModel {
        let newModel = LeaguesViewDataModel(
            count: model.count,
            models: model.competitions.compactMap {
                LeagueViewDataModel(
                    imageUrl: $0.emblem,
                    name: $0.name,
                    code: $0.code,
                    numberOfSeasons: $0.numberOfAvailableSeasons,
                    area: $0.area?.code,
                    type: $0.type
                )
            }
        )
        return newModel
    }
}
