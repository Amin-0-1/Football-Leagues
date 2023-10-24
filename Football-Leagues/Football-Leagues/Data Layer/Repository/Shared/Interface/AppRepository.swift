//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine


//protocol DataSourceProtocol{
//    func fetch<T:Codable>(endPoint:EndPoint?, localEntity:LocalEndPoint?) -> Future<T,Error>
//    func save<T:Codable>(data:T,localEndPoint:LocalEndPoint)->Future<Bool,Error>
//}


class AppRepository:RepositoryInterface{
    
    
    private var remoteDataSource:RemoteRepositoryInterface!
    private var localDataSource:LocalRepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    
    init(remote:RemoteRepositoryInterface = RemoteRepository(),
         local:LocalRepositoryInterface = LocalRepository()) {
        self.remoteDataSource = remote
        self.localDataSource = local
    }
    
    func fetch<T:Codable>(localEndPoint: LocalEndPoint) -> Future<T, Error> {
        return self.localDataSource.fetch(localEndPoint: localEndPoint)
    }
    
    func fetch<T:Codable>(remoteEndPoint: EndPoint) -> Future<T, Error> {
        return self.remoteDataSource.fetch(remoteEndPoint: remoteEndPoint)
    }

    func save<T:Codable>(data: T, localEndPoint: LocalEndPoint) -> Future<Bool, Error> {
        // MARK: - we only save data locally
        return localDataSource.save(data: data, localEndPoint: localEndPoint)
    }
}
