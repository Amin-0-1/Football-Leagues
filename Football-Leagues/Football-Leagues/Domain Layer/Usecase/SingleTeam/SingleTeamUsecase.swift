//
//  SingleTeamUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

protocol SingleTeamUsecaseProtocol{
    
}
struct SignleTeamUsecase:SingleTeamUsecaseProtocol{
    let repo:SingleTeamRepository
    
    init(repo: SingleTeamRepository = SingleTeamRepository()) {
        self.repo = repo
    }
}
