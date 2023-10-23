//
//  LeagueDetailsRepository.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsRepositoryInteface{
    func fetchLocalTeams(localEntityType:LocalEndPoint) ->Future<LeagueDetailsDataModel,Error>
    func fetchRemoteTeams(endpoint:EndPoint)-> Future<LeagueDetailsDataModel,Error>
    func saveTeam(model:LeagueDetailsDataModel,localEntity:LocalEndPoint) ->Future<Bool,Error>
}
class LeagueDetailsRepository:LeagueDetailsRepositoryInteface{

    private var appRepo:RepositoryInterface
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: RepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }

    func fetchLocalTeams(localEntityType: LocalEndPoint) -> Future<LeagueDetailsDataModel, Error> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            appRepo.fetch(endPoint: nil, localEntity: localEntityType).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &self.cancellables)

        }
    }
    func fetchRemoteTeams(endpoint: EndPoint) -> Future<LeagueDetailsDataModel, Error> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            self.appRepo.fetch(endPoint: endpoint, localEntity: nil).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        print(error)
                        promise(.failure(error))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &self.cancellables)
            
        }
    }

//    func fetchTeams(endPoint:EndPoint,localEntityType:LocalEntityType)->Future<TeamsDataModel,CustomDomainError> {
//
//        return Future<TeamsDataModel,CustomDomainError>{[weak self] promise in
//            guard let self = self else {return}
//            self.appRepo.fetch(endPoint: endPoint, localEntity: localEntityType).sink { completion in
//                switch completion{
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        if let networkError = error as? NetworkError{
//                            let customError = CustomDomainError.customError(networkError.localizedDescription)
//                            promise(.failure(customError))
//                        }else if let coreDataError = error as? CoreDataManager.Errors{
//                            let customError = CustomDomainError.customError(coreDataError.localizedDescription)
//                            promise(.failure(customError))
//                        }
//                        promise(.failure(.customError(error.localizedDescription)))
//                }
//            } receiveValue: { model in
//                promise(.success(model))
//            }.store(in: &self.cancellables)
//        }
//    }
    
    func saveTeam(model: LeagueDetailsDataModel,localEntity:LocalEndPoint) -> Future<Bool, Error> {
        return appRepo.save(data: model, localEntity: localEntity)
    }

}
