//
//  FakeLeagueDetailsUsecase.swift
//  Football-LeaguesTests
//
//  Created by Amin on 24/10/2023.
//

import Foundation
import Combine
import Football_Leagues
class FakeLeagueDetailUsecase: LeagueDetailsUsecaseProtocol {
    
    let error = "FakeLeagueDetailUsecase.error"
    var shouldFetch: Bool
    var isFetchedSucess = false
    var teamCount = 0
    
    init(shouldFetch: Bool = true) {
        self.shouldFetch = shouldFetch
    }
    
    func fetchTeams(withData: String) -> Future<Football_Leagues.LeagueDetailsDataModel, Football_Leagues.CustomDomainError> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            if self.shouldFetch {
                guard let decoded = FakeJsonDecoder()
                .getModelFrom(jsonFile: "StubLeagueDetails", decodeType: LeagueDetailsDataModel.self) else {
                    promise(.failure(.serverError))
                    return
                }
                teamCount = decoded.count ?? 0
                isFetchedSucess = true
                promise(.success(decoded))
            } else {
                promise(.failure(.customError(error)))
            }
        }
    }
    func prepareForFakePublish(model: LeagueDetailsDataModel) -> LeaguesDetailsViewDataModel {
        let newModel = LeaguesDetailsViewDataModel(
            header: nil,
            countOfTeams: model.count,
            models: model.teams?.compactMap {
                LeagueDetailsViewDataModel(
                    id: $0.id,
                    image: $0.crest,
                    name: $0.shortName,
                    shortName: $0.tla,
                    colors: [],
                    link: $0.website,
                    stadium: $0.venue,
                    address: $0.address,
                    foundation: $0.founded?.description
                )
            } ?? []
        )
        return newModel
    }
}
