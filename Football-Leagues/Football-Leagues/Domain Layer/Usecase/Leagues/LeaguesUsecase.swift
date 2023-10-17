//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol LeaguesUsecaseProtocol{
    func fetch(completion:@escaping (Result<LeagueDataModel,Error>)->Void)
}

struct LeaguesUsecase : LeaguesUsecaseProtocol{

    
    private var leaguesRepo:LeaguesRepoInterface!
    
    init(leaguesRepo: LeaguesRepoInterface) {
        self.leaguesRepo = leaguesRepo
    }
    func fetch(completion: @escaping (Result<LeagueDataModel, Error>) -> Void) {
        leaguesRepo.fetch(endPoint: LeaguesEndPoints.getAllLeagues) { result in
            switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let failure):
                    completion(.failure(failure))
            }
        }
        
//        leaguesRepo.fetch(endPoint: LeaguesEndPoints., completion: <#T##(Result<LeagueDataModel, Error>) -> Void#>)
    }
}
