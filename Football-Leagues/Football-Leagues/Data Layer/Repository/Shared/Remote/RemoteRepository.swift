//
//  RemoteDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

class RemoteRepository:RemoteRepositoryInterface{
        
    private var apiClinet:APIClientProtocol!
    private var cancellables: Set<AnyCancellable> = []
    init(apiClinet: APIClientProtocol = APIClient.shared) {
        self.apiClinet = apiClinet
    }
    
    func fetch<T:Codable>(endPoint: EndPoint, type: T.Type) -> Future<T, Error> {
        return Future<T,Error>{[weak self] promise in
            guard let self = self else {return}
            self.apiClinet.execute(request: endPoint, type: type).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        let error = NSError(domain: error.localizedDescription, code: 0)
                        promise(.failure(error))
                }
            } receiveValue: { value in
                promise(.success(value))
            }.store(in: &self.cancellables)

        }
        
    }
}
