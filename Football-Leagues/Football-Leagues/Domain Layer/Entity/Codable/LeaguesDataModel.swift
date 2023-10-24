//
//  LeaguesDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

struct LeaguesDataModel: Codable {
    let count: Int?
    var competitions: [Competition]
}

struct Competition: Codable {
    let id: Int?
    let area: Area?
    let name, code, type: String?
    let emblem: String?
    let numberOfAvailableSeasons: Int?
    
}
