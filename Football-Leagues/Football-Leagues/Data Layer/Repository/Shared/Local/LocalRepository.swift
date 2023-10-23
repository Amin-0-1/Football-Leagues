//
//  LocalDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import CoreData
import Combine

class LocalRepository:DataSourceProtocol{
    
    var localClient: CoreDataManagerProtocol
    var cancellables: Set<AnyCancellable> = []
    
    init(localClient: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.localClient = localClient
    }
    
    func fetch<T:Codable>(endPoint endPoin: EndPoint?, localEntity: LocalEndPoint?) -> Future<T, Error> {
        guard let localEntity = localEntity else {return .init { promise in
            promise(.failure(CoreDataManager.Errors.uncompleted))
        }}
        return self.localClient.fetch(localEntityType: localEntity)
    }
    
    func save<T:Codable>(data: T, localEntity: LocalEndPoint) -> Future<Bool, Error> {
        return localClient.insert(data: data,localEntityType: localEntity)
    }
}
