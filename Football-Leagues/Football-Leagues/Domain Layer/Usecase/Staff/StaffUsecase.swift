//
//  StaffUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import Foundation
import Combine

protocol StaffUsecaseProtocol {
    func fetchStaff(withTeamID: Int) -> Future<StaffDataModel, CustomDomainError>
}
class StaffUsecase: StaffUsecaseProtocol {
    var repo: StaffRepositoryInterface
    var connectivity: ConnectivityProtocol
    private var cancellables: Set<AnyCancellable> = []
    init(
        repo: StaffRepositoryInterface = StaffRepository(),
        connectivity: ConnectivityProtocol = ConnectivityService()
    ) {
        self.repo = repo
        self.connectivity = connectivity
    }
    
    func fetchStaff(withTeamID id: Int) -> Future<StaffDataModel, CustomDomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            repo.fetchLocalStaff(localEndpoint: .staff(id: id)).sink { completion in
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.connectivity.isConnected { hasInternet in
                            if !hasInternet {
                                promise(.failure(CustomDomainError.customError(error.localizedDescription)))
                                if let networkError = error as? NetworkError {
                                    let customError = CustomDomainError.customError(networkError.localizedDescription)
                                    print(error)
                                    promise(.failure(customError))
                                } else if let coreDataError = error as? CoreDataManager.Errors {
                                    let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                                    print(error)
                                    promise(.failure(customError))
                                }
                                promise(.failure(.customError(error.localizedDescription)))
                                return
                            } else {
                                self.fetchRemoteStaff(endPoint: LeaguesEndPoints.getStaff(id: id)) { completion in
                                    switch completion {
                                        case .success(let success):
                                            promise(.success(success))
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                    }
                                }
                            }
                            
                        }
                }
            } receiveValue: { model in
                promise(.success(model))
                
                // MARK: - update local staff
                self.connectivity.isConnected { hasInternet in
                    if !hasInternet {
                        promise(.failure(.connectionError))
                    } else {
                        self.fetchRemoteStaff(endPoint: LeaguesEndPoints.getStaff(id: id)) { completion in
                            switch completion {
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
    
    private func fetchRemoteStaff(
        endPoint: EndPoint,
        onFinish: @escaping (Result<StaffDataModel, CustomDomainError>) -> Void
    ) {
        self.repo.fetchRemoteStaff(remoteEndPoint: endPoint).sink { completion in
            switch completion {
                case .finished: break
                case .failure(let error):
                    let errorDomain = (error as NSError).domain
                    onFinish(.failure(CustomDomainError.customError(errorDomain)))
            }
        } receiveValue: {[weak self] model in
            guard let self = self else {return}
            onFinish(.success(model))
            if let endpoint = endPoint as? LeaguesEndPoints, let id = Int(endpoint.code ?? "") {
                self.save(model: model, localEntityType: .staff(id: id))
            }
        }.store(in: &self.cancellables)
        
    }
    // MARK: - update local data
    private func save(model: StaffDataModel, localEntityType: LocalEndPoint) {
        repo.saveStaff(model: model, localEndPoint: localEntityType).sink { completion in
            switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
            }
        } receiveValue: { _ in
            // print("local \(localEntityType) saved -> \(isSaved)")
        }.store(in: &cancellables)
    }
}
