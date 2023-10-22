//
//  SingleTeamRepository.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine

protocol GamesRepositoryProtocol{
    func fetchGames(endPoint: EndPoint,localEntityType:LocalEntityType)->Future<GamesDataModel,CustomDomainError>
    func save(model:GamesDataModel,localEntityType:LocalEntityType)->Future<Bool,Error>
}
class GamesRepository:GamesRepositoryProtocol{
    
    private let appRepo:AppRepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
    func fetchGames(endPoint: EndPoint,localEntityType:LocalEntityType)->Future<GamesDataModel,CustomDomainError> {
        return Future<GamesDataModel,CustomDomainError>{ [weak self] promise in
            guard let self = self else {return}
            appRepo.fetch(endPoint: endPoint, localEntityType: localEntityType).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        if let networkError = error as? NetworkError{
                            let customError = CustomDomainError.customError(networkError.localizedDescription)
                            print(error)
                            promise(.failure(customError))
                        }else if let coreDataError = error as? CoreDataManager.Errors{
                            let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                            print(error)
                            promise(.failure(customError))
                        }
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }
    func save(model: GamesDataModel, localEntityType: LocalEntityType) -> Future<Bool, Error> {
        return appRepo.save(data: model, localEntityType: localEntityType)
    }
}
