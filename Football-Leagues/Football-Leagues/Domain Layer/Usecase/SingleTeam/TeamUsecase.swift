//
//  SingleTeamUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine

protocol TeamUsecaseProtcol{
    func fetchGames(withTeamID:Int)-> Future<TeamDataModel,CustomDomainError>
}
class TeamUsecase:TeamUsecaseProtcol{
    
    private let gamesRepo:TeamRepositoryProtocol!
    private var cancellables:Set<AnyCancellable> = []
    private var connectivity:ConnectivityProtocol!
    init(repo: TeamRepositoryProtocol = TeamRepository(),
         connectivity:ConnectivityProtocol = ConnectivityService()) {
        self.gamesRepo = repo
        self.connectivity = connectivity
    }
    
    func fetchGames(withTeamID id: Int) -> Future<TeamDataModel, CustomDomainError> {
        
        return .init{[weak self] promise in
            guard let self = self else {return}
            // MARK: - fetch local data
            self.gamesRepo.fetchLocalGames(localEndpoint: .games(id: id)).sink { completion in
                switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        self.connectivity.isConnected { hasInternet in
                            if !hasInternet{
                                if let networkError = error as? NetworkError{
                                    let customError = CustomDomainError.customError(networkError.localizedDescription)
                                    print(error)
                                    promise(.failure(customError))
                                }else if let coreDataError = error as? CoreDataManager.Errors{
                                    let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                                    print(error)
                                    promise(.failure(customError))
                                }
                                promise(.failure(.customError(error.localizedDescription)))
                                return
                            }else{
                                self.fetchRemoteGames(endPoint: LeaguesEndPoints.getGames(id: id)) { completion in
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
                // MARK: - local data fetched
                promise(.success(model))
                
                self.connectivity.isConnected { hasInternet in
                    if !hasInternet{
                        promise(.failure(.connectionError))
                    }else{
                        self.fetchRemoteGames(endPoint: LeaguesEndPoints.getGames(id: id)) { completion in
                            switch completion {
                                case .success(let success):
                                    promise(.success(success))
                                case .failure(let failure):
                                    promise(.failure(failure))
                            }
                        }
                    }
                }
                
            }.store(in: &self.cancellables)
        }
    }
    
    private func fetchRemoteGames(endPoint:EndPoint,onFinish:@escaping (Result<TeamDataModel,CustomDomainError>)->Void){
        self.gamesRepo.fetchRemoteGames(remoteEndPoint: endPoint).sink { completion in
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
            onFinish(.success(model))
            if let endpoint = endPoint as? LeaguesEndPoints,let id = Int(endpoint.code ?? ""){
                self.save(model: model, localEntityType: .games(id: id))
            }
        }.store(in: &self.cancellables)
        
    }
    
    // MARK: - update local data
    private func save(model:TeamDataModel,localEntityType:LocalEndPoint){
        gamesRepo.saveGames(model: model, localEndPoint: localEntityType).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
            }
        } receiveValue: { isSaved in
            print("local \(localEntityType) saved -> \(isSaved)")
        }.store(in: &cancellables)
    }
}
