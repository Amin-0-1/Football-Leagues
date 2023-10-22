//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol LeaguesUsecaseProtocol{
    func fetchLeagues() -> Future<LeagueDataModel,CustomDomainError>
}

class LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(leaguesRepo: LeaguesRepoInterface = LeaguesReposiotory()) {
        self.leaguesRepo = leaguesRepo
    }
    
    
    func fetchLeagues() -> Future<LeagueDataModel, CustomDomainError> {
        return Future<LeagueDataModel,CustomDomainError> { promise in
            self.leaguesRepo.fetchLeagues(endPoint: LeaguesEndPoints.getAllLeagues).sink { completion in
                switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error))
                }
            } receiveValue: { model in
                self.save(leagues: model,localEntityType: .leagues)
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }

    private func save(leagues:LeagueDataModel,localEntityType:LocalEntityType){
        leaguesRepo.save(leagues: leagues,localEntityType: .leagues).sink { _ in } receiveValue: { isSaved in
            print(isSaved)
        }.store(in: &cancellables)

    }
    
}

