//
//  LeagueDetailsUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
protocol LeagueDetailsUsecaseProtocol{
    
}

struct LeagueDetailsUsecase:LeagueDetailsUsecaseProtocol{
    private var leageDetailsRepo:LeagueDetailsRepositoryProtocol
    
    init(leageDetailsRepo: LeagueDetailsRepositoryProtocol = LeagueDetailsRepository()) {
        self.leageDetailsRepo = leageDetailsRepo
    }
}
