//
//  LeagueDetailsRepository.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsRepositoryProtocol{
    func fetchTeams(endPoint:EndPoint,localEntityType:LocalEntityType)->Future<TeamsDataModel,CustomDomainError>
    func save(model:TeamsDataModel,localEntityType:LocalEntityType)->Future<Bool,Error>
}
class LeagueDetailsRepository:LeagueDetailsRepositoryProtocol{
    private var appRepo:AppRepositoryInterface
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
    
    func fetchTeams(endPoint:EndPoint,localEntityType:LocalEntityType)->Future<TeamsDataModel,CustomDomainError> {
        
        return Future<TeamsDataModel,CustomDomainError>{[weak self] promise in
            guard let self = self else {return}
            appRepo.fetch(endPoint: endPoint, localEntityType: localEntityType).sink { completion in
                switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        if let networkError = error as? NetworkError{
                            let customError = CustomDomainError.customError(networkError.localizedDescription)
                            promise(.failure(customError))
                        }else if let coreDataError = error as? CoreDataManager.Errors{
                            let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                            promise(.failure(customError))
                        }
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }
    func save(model: TeamsDataModel, localEntityType: LocalEntityType) -> Future<Bool, Error> {
        return appRepo.save(data: model, localEntityType: localEntityType)
    }
}