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
    func fetch<T:Codable>(model: LocalEntityType) -> Future<T, Error>  {
        return self.localClient.fetch(localEntityType: model)
        
    }
    
    func save<T:Codable>(data: T, localEntityType: LocalEntityType) -> Future<Bool, Error> {
        return localClient.insert(data: data,localEntityType: localEntityType)
    }

}
