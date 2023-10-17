//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol LeaguesUsecaseProtocol{
    func fetch()
}

struct LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    
    init(leaguesRepo: LeaguesRepoInterface) {
        self.leaguesRepo = leaguesRepo
    }
    func fetch() {
        leaguesRepo.fetch { result in
            switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
            }
        }
    }
}
