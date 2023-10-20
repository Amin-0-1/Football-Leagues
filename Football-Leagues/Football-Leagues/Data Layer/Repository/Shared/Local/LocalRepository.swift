//
//  LocalDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import CoreData
import RxSwift
import Combine

class LocalRepository:LocalRepositoryInterface{

    var localClient: CoreDataManagerProtocol
    var cancellables: Set<AnyCancellable> = []
    
    init(localClient: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.localClient = localClient
    }
    
    func fetch<T:Codable>(model: LocalFetchType, type: T.Type) -> Single<Result<T, Error>> {
        return Single.create { single in
            self.localClient.fetch(model: model, type: type).sink { completion in
                switch completion{
                    case .failure(let error):
                        single(.success(.failure(error)))
                    case .finished:
                        break
                }
            } receiveValue: { value in
                single(.success(.success(value)))
            }.store(in: &self.cancellables)

            return Disposables.create()
        }
    }

    func save<T:Codable>(data: T) {
        localClient.insert(data: data)
    }


}
