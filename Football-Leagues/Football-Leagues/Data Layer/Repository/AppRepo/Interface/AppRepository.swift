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
        return remoteDataSource.fetch(remoteEndPoint: remoteEndPoint)
    }

    func save<T: Codable>(data: T, localEndPoint: LocalEndPoint) -> Future<T, Error> {
        // MARK: - we only save data locally
        return localDataSource.save(data: data, localEndPoint: localEndPoint)
    }
}
