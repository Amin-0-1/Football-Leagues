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
    
    func fetch<T>(endPoint: EndPoint, type: T.Type) -> Single<Result<T, Error>> where T : Decodable, T : Encodable {
        return Single.create { single in
            single(.success(.failure(NetworkError.requestFailed)))
            return Disposables.create()
        }
    }
    
    func save(data: [Competition]){
        localClient.insert(competitions: data)
    }

}
