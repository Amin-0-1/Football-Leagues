//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

//protocol AppRepositoryInterface{
//    func fetch<T:Codable>(endPoint: EndPoint,localEntityType:LocalEntityType) -> Future<T,Error>
//    func save<T:Codable>(data: T,localEntityType:LocalEntityType) -> Future<Bool, Error>
//}

// MARK: - either remote or local
protocol DataSourceProtocol{
    func fetch<T:Codable>(endPoint:EndPoint?, localEntity:LocalEndPoint?) -> Future<T,Error>
    func save<T:Codable>(data:T,localEntity:LocalEndPoint)->Future<Bool,Error>
}
class AppRepository:RepositoryInterface{

    
    
//    private var local:LocalRepositoryInterface!
//    private var remote:RemoteRepositoryInterface!
    
    private var remoteDataSource:DataSourceProtocol
    private var localDataSource:DataSourceProtocol
    
    private var cancellables:Set<AnyCancellable> = []
    init(remote:DataSourceProtocol = RemoteRepository(),local:DataSourceProtocol = LocalRepository()) {
        self.remoteDataSource = remote
        self.localDataSource = local
    }
    
    func fetch<T:Codable>(endPoint: EndPoint?,localEntity localEntityType:LocalEndPoint?) -> Future<T,Error>{
        return .init{ [weak self] promise in
            guard let self = self else {return}
            guard let endpoint = endPoint else {
                // MARK: - fetch local data
                self.localDataSource.fetch(endPoint: endPoint, localEntity: localEntityType).sink { completion in
                    self.localDataSource.fetch(endPoint: endPoint, localEntity: localEntityType).sink { completion in
                        switch completion{
                            case .finished:break
                            case .failure(let error):
                                promise(.failure(error))
                        }
                    } receiveValue: { model in
                        promise(.success(model))
                    }.store(in: &self.cancellables)

                } receiveValue: { model in
                    promise(.success(model))
                }.store(in: &self.cancellables)
                return
            }
            // MARK: - fetch remote data
            self.remoteDataSource.fetch(endPoint: endpoint, localEntity: localEntityType).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &cancellables)

        }
        
    }
    func save<T:Codable>(data: T, localEntity: LocalEndPoint) -> Future<Bool, Error> {
        // MARK: - we only save data locally
        return localDataSource.save(data: data, localEntity: localEntity)
    }
}
