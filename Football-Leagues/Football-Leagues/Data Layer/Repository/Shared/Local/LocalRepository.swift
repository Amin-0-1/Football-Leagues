//
//  LocalDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

struct LocalRepository:RepositoryInterface{
    
    func fetch<T:Codable>(endPoint: EndPoint?,type:T.Type) -> Single<Result<T, Error>> {
        return Single.create { single in
            single(.success(.failure(NetworkError.requestFailed)))
            return Disposables.create()
        }
    }

}
