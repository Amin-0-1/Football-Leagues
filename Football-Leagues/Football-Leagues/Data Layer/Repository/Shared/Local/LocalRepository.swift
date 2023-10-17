//
//  LocalDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

struct LocalRepository:RepositoryInterface{
    
    func fetch<T:Decodable>(endPoint:EndPoint?,completion: @escaping (Result<T,Error>)->Void) {
        
    }
}
