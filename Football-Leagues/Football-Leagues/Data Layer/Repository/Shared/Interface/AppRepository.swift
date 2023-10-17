//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

// MARK: - single interface for a complex subsystems

struct AppRepository:RepositoryInterface{
    
    private var local:RepositoryInterface!
    private var remote:RepositoryInterface!
    
    init(local: RepositoryInterface, remote: RepositoryInterface) {
        self.local = local
        self.remote = remote
    }
    
    func fetch<T:Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        isConnected { isConnected in
            
            
            
            
            
            
            
        }
    }
}

