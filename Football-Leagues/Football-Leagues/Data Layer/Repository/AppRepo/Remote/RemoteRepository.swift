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
        return .init { [weak self] promise in
            guard let self = self else {return}
            self.apiClinet.execute(request: remoteEndPoint).sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &cancellables)

        }
    }
    
}
