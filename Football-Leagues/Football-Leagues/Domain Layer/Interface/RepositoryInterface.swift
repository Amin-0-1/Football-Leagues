//
//  RepositoryInterface.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

typealias RepositoryInterface = RemoteRepositoryInterface & LocalRepositoryInterface
protocol RemoteRepositoryInterface{
    func fetch<T:Codable>(endPoint:EndPoint,type:T.Type) -> Single<Result<T,Error>>
}

protocol LocalRepositoryInterface{
    func fetch<T:Codable>(model:LocalFetchType,type:T.Type) -> Single<Result<T,Error>>
    func save<T:Codable>(data:T)
}
 
