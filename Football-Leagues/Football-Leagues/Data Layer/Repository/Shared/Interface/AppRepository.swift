//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol AppRepositoryInterface{
    func fetch<T:Codable>(endPoint: EndPoint,localFetchType:LocalFetchType,type: T.Type) -> Future<T,Error>
    func save<T:Codable>(data: T) -> Future<Bool, Error>
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
    
    func fetch<T:Codable>(endPoint: EndPoint,localFetchType:LocalFetchType,type: T.Type) -> Future<T,Error>{
        return Future<T,Error> { [weak self] promise in
            guard let self = self else {return}
            // MARK: - local fetch
                        
            self.local.fetch(model: localFetchType, type: type).sink { completion in
                switch completion{
                    case .finished:
                        print("finished")
                    case .failure(let error):
                        Connection { isConnected in
                            if !isConnected{
                                promise(.failure(error))
                            }else{
                                // MARK: - remote fetch
                                self.remote.fetch(endPoint: endPoint, type: type).sink { completion in
                                    switch completion{
                                        case .finished: break
                                        case .failure(let error):
                                            promise(.failure(error))
                                    }
                                } receiveValue: { model in
                                    self.save(data: model)
                                    promise(.success(model))
                                }.store(in: &self.cancellables)
                                // end of remote fetch
                            }
                        }
                }
            } receiveValue: { value in
                promise(.success(value))
            }.store(in: &self.cancellables)

        }
        
    }
    
    func save<T:Codable>(data: T) -> Future<Bool, Error>  {
        return local.save(data: data)
    }
    
}

