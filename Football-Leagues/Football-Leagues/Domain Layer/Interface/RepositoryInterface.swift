//
//  RepositoryInterface.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

typealias RepositoryInterface = RemoteRepositoryInterface & LocalRepositoryInterface
protocol RemoteRepositoryInterface{
    func fetch<T:Codable>(endPoint: EndPoint, type: T.Type) -> Future<T, Error>
}

protocol LocalRepositoryInterface{
    func fetch<T:Codable>(model:LocalFetchType,type:T.Type) -> Future<T,Error>
    func save<T:Codable>(data:T)->Future<Bool,Error>
}
 
