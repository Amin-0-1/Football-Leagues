//
//  LeagueDetailsRepository.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation

protocol LeagueDetailsRepositoryProtocol{
    
}
struct LeagueDetailsRepository:LeagueDetailsRepositoryProtocol{
    private var appRepo:AppRepositoryInterface
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
}
