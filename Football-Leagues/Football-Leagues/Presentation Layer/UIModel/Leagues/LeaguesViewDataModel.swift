//
//  LeaguesViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

struct LeaguesViewDataModel {
    let count: Int?
    let models: [LeagueViewDataModel]
}

struct LeagueViewDataModel {
    let imageUrl: String?
    let name: String?
    let code: String?
    let numberOfSeasons: Int?
    let area: String?
    let type: String?
}
