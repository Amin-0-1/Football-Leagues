//
//  RemoteDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

class RemoteRepository: RemoteRepositoryInterface {
        
    private var apiClinet: APIClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    init(apiClinet: APIClientProtocol = APIClient.shared) {
        self.apiClinet = apiClinet
    }
    func fetch<T: Codable>(remoteEndPoint: EndPoint) -> Future<T, Error> {
        return apiClinet.execute(request: remoteEndPoint)
    }
    
}
