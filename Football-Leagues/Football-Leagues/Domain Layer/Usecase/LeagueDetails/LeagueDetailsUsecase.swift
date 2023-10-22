//
//  LeagueDetailsUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsUsecaseProtocol{
    func fetchTeams(withData: String)->Future<TeamsDataModel,CustomDomainError>
}

class LeagueDetailsUsecase:LeagueDetailsUsecaseProtocol{

    private var leageDetailsRepo:LeagueDetailsRepositoryProtocol
    private var cancellables:Set<AnyCancellable> = []
    init(leageDetailsRepo: LeagueDetailsRepositoryProtocol = LeagueDetailsRepository()) {
        self.leageDetailsRepo = leageDetailsRepo
    }
    
    func fetchTeams(withData code: String) -> Future<TeamsDataModel, CustomDomainError> {
        return Future<TeamsDataModel,CustomDomainError>{ [weak self] promise in
            guard let self = self else {
                promise(.failure(.customError("")))
                return
            }
            
            leageDetailsRepo.fetchTeams(endPoint: LeaguesEndPoints.getTeams(code: code), localEntityType: .teams(code: code)).sink { completion in
                switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                }
            } receiveValue: { [weak self] model in
                self?.save(model: model, localEntityType: .teams(code: code))
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }
    
    private func save(model:TeamsDataModel,localEntityType:LocalEntityType){
        leageDetailsRepo.save(model: model, localEntityType: localEntityType).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    debugPrint(error)
            }
        } receiveValue: { isSaved in
            debugPrint(isSaved)
        }.store(in: &cancellables)
    }
}
