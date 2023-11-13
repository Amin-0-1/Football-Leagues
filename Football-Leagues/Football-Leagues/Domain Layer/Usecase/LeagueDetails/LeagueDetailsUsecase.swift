//
//  LeagueDetailsUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsUsecaseProtocol {
    func fetchTeams(withData: String) -> Future<LeagueDetailsDataModel, CustomDomainError>
}

class LeagueDetailsUsecase: LeagueDetailsUsecaseProtocol {

    private var leageDetailsRepo: LeagueDetailsRepositoryInteface
    private var connectivity: ConnectivityProtocol
    private var cancellables: Set<AnyCancellable> = []
    init(
        leageDetailsRepo: LeagueDetailsRepositoryInteface = LeagueDetailsRepository(),
        connectivity: ConnectivityProtocol = ConnectivityService()
    ) {
        self.leageDetailsRepo = leageDetailsRepo
        self.connectivity = connectivity
    }
    
    func fetchTeams(withData code: String) -> Future<LeagueDetailsDataModel, CustomDomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            // MARK: - fetch local data
            leageDetailsRepo.fetchLocalTeams(localEndPoint: .teams(code: code)).sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.connectivity.isConnected { hasInternet in
                            if hasInternet {
                                
                                self.fetchRemoteTeams(endPoint: LeaguesEndPoints.getTeams(code: code)) { completion in
                                    switch completion {
                                        case .success(let success):
                                            promise(.success(success))
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                    }
                                }
                            } else {
                                if let networkError = error as? NetworkError {
                                    let customError = CustomDomainError.customError(networkError.localizedDescription)
                                    promise(.failure(customError))
                                } else if let coreDataError = error as? CoreDataManager.Errors {
                                    let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                                    promise(.failure(customError))
                                }
                                promise(.failure(.customError(error.localizedDescription)))
                            }
                        }
                }
            } receiveValue: { model in
                // MARK: - local data fetched
                promise(.success(model))
                self.connectivity.isConnected { hasInternet in
                    if !hasInternet {
                        promise(.failure(.connectionError))
                    } else {
                        // MARK: - fetch remote data
                        self.fetchRemoteTeams(endPoint: LeaguesEndPoints.getTeams(code: code)) { result in
                            switch result {
                                case .success(let success):
                                    promise(.success(success))
                                case .failure(let failure):
                                    promise(.failure(failure))
                            }
                        }
                    }
                }
            }.store(in: &cancellables)

        }
    }
    
    private func fetchRemoteTeams(endPoint: EndPoint, onFinish: @escaping (Result<LeagueDetailsDataModel, CustomDomainError>) -> Void) {
        leageDetailsRepo.fetchRemoteTeams(remoteEndPoint: endPoint).sink { completion in
            switch completion {
                case .finished: break
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        let customError = CustomDomainError.customError(networkError.localizedDescription)
                        onFinish(.failure(customError))
                    } else if let coreDataError = error as? CoreDataManager.Errors {
                        let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                        onFinish(.failure(customError))
                    }
                    onFinish(.failure(CustomDomainError.customError(error.localizedDescription)))
            }
        } receiveValue: {[weak self] model in
            guard let self = self else {return}
            onFinish(.success(model))
            if let endpoint = endPoint as? LeaguesEndPoints, let code = endpoint.code?.description {
                self.save(model: model, localEntityType: .teams(code: code))
            }
        }.store(in: &self.cancellables)
        
    }
    
    private func save(model: LeagueDetailsDataModel, localEntityType: LocalEndPoint) {
        leageDetailsRepo.saveTeam(model: model, localEndPoint: localEntityType).sink {  completion in
            switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        } receiveValue: {isSaved in
            print("local \(localEntityType) saved -> \(isSaved)")
        }.store(in: &cancellables)
    }
}
