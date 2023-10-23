//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol AppRepositoryInterface{
    func fetch<T:Codable>(endPoint: EndPoint,localEntityType:LocalEntityType) -> Future<T,Error>
    func save<T:Codable>(data: T,localEntityType:LocalEntityType) -> Future<Bool, Error>
}

// MARK: - single interface for a complex subsystems
class AppRepository:AppRepositoryInterface{

   
    private var local:LocalRepositoryInterface!
    private var remote:RemoteRepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(local: LocalRepositoryInterface = LocalRepository(), remote: RemoteRepositoryInterface = RemoteRepository()) {
        self.local = local
        self.remote = remote
    }
    
    func fetch<T:Codable>(endPoint: EndPoint,localEntityType:LocalEntityType) -> Future<T,Error>{
        return Future<T,Error> { [weak self] promise in
            guard let self = self else {return}
            // MARK: - local fetch
            
            self.local.fetch(model: localEntityType).sink { completion in
                switch completion{
                        // MARK: - failed to fetch local data
                    case .failure(let error):
                        Connection { isConnected in
                            if !isConnected{
                                promise(.failure(error))
                            }else{
                                self.fetchRemoteData(endPoint: endPoint,type: T.self) { result in
                                    switch result {
                                        case .success(let model):
                                            promise(.success(model))
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                    }
                                }
                            }
                        }
                    case .finished:
                        Connection { isConnected in
                            if !isConnected{
                                promise(.failure(NetworkError.noInternetConnection))
                            }else{
                                self.fetchRemoteData(endPoint: endPoint, type: T.self) { result in
                                    switch result {
                                        case .success(let model):
                                            promise(.success(model))
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                    }
                                }
                            }
                        }
                }
            } receiveValue: { value in
                // MARK: - local data fetched successfully
                promise(.success(value))
            }.store(in: &self.cancellables)

        }
        
    }
    func save<T:Codable>(data: T,localEntityType:LocalEntityType) -> Future<Bool, Error>  {
        return local.save(data: data,localEntityType: localEntityType)
    }
    
    private func fetchRemoteData<T:Codable>(endPoint: EndPoint,type:T.Type,completion:@escaping (Result<T,Error>)->Void){
        self.remote.fetch(endPoint: endPoint).sink { completionState in
            switch completionState{
                case .finished: break
                case .failure(let error):
                    completion(.failure(error))
            }
        } receiveValue: { model in
            completion(.success(model))
        }.store(in: &self.cancellables)


    }
}

