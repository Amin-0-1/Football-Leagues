//
//  RepositoryInterface.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol RepositoryInterface{
    func fetch<T:Decodable>(completion: @escaping (Result<T,Error>)->Void)
}
