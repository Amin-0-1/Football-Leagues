//
//  LeaguesViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

class LeaguesVieweDataModel{
    
    let imageUrl: String?
    let title: String?
    let code: String?
    var numberOfTeams: Int?
    var numberOfMatches: Int?
    var numberOfSeasons: Int?
    
    init(imageUrl: String?, title: String?, code: String?, numberOfTeams: Int? = nil, numberOfMatches: Int? = nil, numberOfSeasons: Int? = nil) {
        self.imageUrl = imageUrl
        self.title = title
        self.code = code
        self.numberOfTeams = numberOfTeams
        self.numberOfMatches = numberOfMatches
        self.numberOfSeasons = numberOfSeasons
    }
}
