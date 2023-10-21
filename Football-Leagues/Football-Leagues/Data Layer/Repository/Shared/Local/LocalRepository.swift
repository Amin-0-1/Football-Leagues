//
//  LocalDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import CoreData
import Combine

class LocalRepository:LocalRepositoryInterface{

    var localClient: CoreDataManagerProtocol
    var cancellables: Set<AnyCancellable> = []
    
    init(localClient: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.localClient = localClient
    }
    func fetch<T:Codable>(model: LocalFetchType, type: T.Type) -> Future<T, Error>  {
        return self.localClient.fetch(model: model, type: type)
        
    }
    
    func save<T:Codable>(data: T) -> Future<Bool, Error> {
        return localClient.insert(data: data)
    }

}
