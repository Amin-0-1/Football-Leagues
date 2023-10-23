//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol LeaguesUsecaseProtocol{
    func fetchLeagues() -> Future<LeaguesDataModel,CustomDomainError>
}

class LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    private var connectivity:ConnectivityProtocol!
    private var cancellables:Set<AnyCancellable> = []
    init(leaguesRepo: LeaguesRepoInterface = LeaguesReposiotory(),
         connectivity:ConnectivityProtocol = ConnectivityService()) {
        self.leaguesRepo = leaguesRepo
        self.connectivity = connectivity
    }
    
    func fetchLeagues() -> Future<LeaguesDataModel, CustomDomainError> {
        return .init { promise in
            self.fetchRemoteLeagues(endPoint: LeaguesEndPoints.getAllLeagues) { result in
                promise(result)
            }
        }
//        return .init{ [weak self] promise in
//            guard let self = self else {return}
//
//            // MARK: - fetch local data
//            self.leaguesRepo.fetchLocalLeagues(localEntityType: .leagues).sink { completion in
//                switch completion{
//                    case .finished: break
//                    case .failure(let error):
//                        self.connectivity.isConnected { hasInternet in
//                            if !hasInternet{
//                                if let networkError = error as? NetworkError{
//                                    let customError = CustomDomainError.customError(networkError.localizedDescription)
//                                    promise(.failure(customError))
//                                }else if let coreDataError = error as? CoreDataManager.Errors{
//                                    let customError = CustomDomainError.customError(coreDataError.localizedDescription)
//                                    promise(.failure(customError))
//                                }
//                                promise(.failure(.customError(error.localizedDescription)))
//                            }else{
//                                // MARK: - fetch remote data
//                                self.fetchRemoteLeagues(endPoint:LeaguesEndPoints.getAllLeagues) { result in
//                                    switch result {
//                                        case .success(let success):
//                                            promise(.success(success))
//                                        case .failure(let failure):
//                                            promise(.failure(failure))
//                                    }
//                                }
//                            }
//                        }
//                }
//            } receiveValue: { model in
//                // MARK: - on local data fetched
//                promise(.success(model))
//                // get remote data to update local
//                self.connectivity.isConnected { hasInternet in
//                    if !hasInternet{
//                        promise(.failure(.connectionError))
//                    }else{
//                        // MARK: - fetch remote data
//                        self.fetchRemoteLeagues(endPoint:LeaguesEndPoints.getAllLeagues) { result in
//                            switch result {
//                                case .success(let success):
//                                    promise(.success(success))
//                                case .failure(let failure):
//                                    promise(.failure(failure))
//                            }
//                        }
//                    }
//                }
//
//            }.store(in: &self.cancellables)
//        }
        
        
    }
    private func fetchRemoteLeagues(endPoint:EndPoint,onFinish:@escaping (Result<LeaguesDataModel,CustomDomainError>)->Void){
        leaguesRepo.fetchRemoteLeagues(endpoint: endPoint).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    if let networkError = error as? NetworkError{
                        let customError = CustomDomainError.customError(networkError.localizedDescription)
                        onFinish(.failure(customError))
                    }else if let coreDataError = error as? CoreDataManager.Errors{
                        let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                        onFinish(.failure(customError))
                    }
                    onFinish(.failure(CustomDomainError.customError(error.localizedDescription)))
            }
        } receiveValue: { model in
            self.save(leagues: model, localEntityType: .leagues)
            onFinish(.success(model))
        }.store(in: &self.cancellables)

    }
    // MARK: - update local data
    private func save(leagues:LeaguesDataModel,localEntityType:LocalEndPoint){
        leaguesRepo.saveLeagues(leagues: leagues,localEntity: localEntityType).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        } receiveValue: { isSaved in
            print("local \(localEntityType) saved -> \(isSaved)")
        }.store(in: &cancellables)
        
    }
}

