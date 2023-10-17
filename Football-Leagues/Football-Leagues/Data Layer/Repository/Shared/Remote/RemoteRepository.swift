//
//  RemoteDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

struct RemoteRepository:RepositoryInterface{
    private var apiClinet:APIClientProtocol!
    
    init(apiClinet: APIClientProtocol!) {
        self.apiClinet = apiClinet
    }
    func fetch<T:Codable>(endPoint:EndPoint?,completion: @escaping (Result<T,Error>)->Void) {
        guard let endPoint = endPoint else {return}
        apiClinet.execute(request: endPoint, completion: completion)
    }
}
