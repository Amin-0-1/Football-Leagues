//
//  SeasonDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation


struct SeasonDataModel: Codable {
    let area: Area?
    let id: Int?
    let name, code, type: String?
    let emblem: String?
    let currentSeason: Season?
    let seasons: [Season]?
    let lastUpdated: String?
}

struct Season: Codable {
    let id: Int?
    let startDate, endDate: String?
    let currentMatchday: Int?
    let winner: Winner?
    let stages: String?
}


struct Winner: Codable {
    let id: Int?
    let name, shortName, tla: String?
    let crest: String?
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors: String?
    let venue: String?
    let lastUpdated: String?
}
