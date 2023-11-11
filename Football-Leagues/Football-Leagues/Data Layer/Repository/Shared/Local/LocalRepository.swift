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
    
    init(localClient: CoreDataManagerProtocol = CoreDataManager.configure(model:
                                                                            AppConfiguration.shared.dataModel,
                                                                            store: .sqlite)) {
        self.localClient = localClient
    }

    
    func fetch<T:Codable>(localEndPoint: LocalEndPoint) -> Future<T, Error> {
        return self.localClient.fetch(localEndPoint: localEndPoint)
    }
    
    func save<T:Codable>(data:T,localEndPoint:LocalEndPoint)->Future<T,Error>{
        return localClient.insert(data: data, localEndPoint: localEndPoint)
    }
}
