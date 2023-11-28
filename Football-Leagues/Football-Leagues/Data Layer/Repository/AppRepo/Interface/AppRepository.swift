//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine
import CoreML

// MARK: - FaÇade repository
class AppRepository: RepositoryInterface {
    
    private var remoteDataSource: RemoteRepositoryInterface
    private var localDataSource: LocalRepositoryInterface
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        remote: RemoteRepositoryInterface = RemoteRepository(),
        local: LocalRepositoryInterface = LocalRepository()
    ) {
        self.remoteDataSource = remote
        self.localDataSource = local
    }
    
    func fetch<T: Codable>(localEndPoint: LocalEndPoint) -> Future<T, Error> {
        return localDataSource.fetch(localEndPoint: localEndPoint)
    }
    
    func fetch<T: Codable>(remoteEndPoint: EndPoint) -> Future<T, Error> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            remoteDataSource.fetch(remoteEndPoint: remoteEndPoint).sink { completion in
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        if let error = error as? NetworkError {
                            switch error {
                                case .serverError(let data):
                                    guard let decodedError = self.decodeServerError(data: data) else {
                                        promise(.failure(error))
                                        return
                                    }
                                    let errorMessage = decodedError.message ?? ""
                                    let errorCode = decodedError.errorCode ?? 400
                                    let customError = NSError(domain: errorMessage, code: errorCode)
                                    promise(.failure(customError))
                                default:
                                    let error = NSError(domain: error.localizedDescription, code: 0)
                                    promise(.failure(error))
                            }
                        }
                        promise(.failure(error))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &cancellables)
            
        }
    }

    func save<T: Codable>(data: T, localEndPoint: LocalEndPoint) -> Future<T, Error> {
        // MARK: - we only save data locally
        return localDataSource.save(data: data, localEndPoint: localEndPoint)
    }
    
    private func decodeServerError(data: Data) -> ErrorDataModel? {
        guard let decoded = try? JSONDecoder().decode(
            ErrorDataModel.self,
            from: data
        ) else {
            return nil
        }
        return decoded
    }
}
