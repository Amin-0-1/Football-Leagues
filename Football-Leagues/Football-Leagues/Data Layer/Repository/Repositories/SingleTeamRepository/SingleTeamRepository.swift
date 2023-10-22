//
//  SingleTeamRepository.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

protocol SingleTeamRepositoryProtocol{
    
}
struct SingleTeamRepository:SingleTeamRepositoryProtocol{
    private let appRepo:AppRepositoryInterface!
    
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
}
