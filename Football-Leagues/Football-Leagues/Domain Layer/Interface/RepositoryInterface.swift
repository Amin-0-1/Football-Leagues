//
//  RepositoryInterface.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

//typealias RepositoryInterface = RemoteRepositoryInterface & LocalRepositoryInterface
//protocol RemoteRepositoryInterface{
//    func fetch<T:Codable>(endPoint: EndPoint) -> Future<T, Error>
//}
//
//protocol LocalRepositoryInterface{
//    func fetch<T:Codable>(model:LocalEntityType) -> Future<T,Error>
//    func save<T:Codable>(data:T,localEntityType:LocalEntityType)->Future<Bool,Error>
//}
//

protocol RepositoryInterface{
    func fetch<T:Codable>(endPoint:EndPoint?, localEntity:LocalEndPoint?) -> Future<T,Error>
    func save<T:Codable>(data:T,localEntity:LocalEndPoint)->Future<Bool,Error>
}
