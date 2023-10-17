//
//  LeaguesDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

struct LeagueDataModel: Decodable {
    let count: Int?
    let competitions: [Competition]
}

struct Competition: Decodable {
    let id: Int?
    let area: Area?
    let name, code, type: String?
    let emblem: String?
    let currentSeason: CurrentSeason
    let numberOfAvailableSeasons: Int
    let lastUpdated: Date
}

struct Area: Decodable {
    let id: Int
    let name, code: String
    let flag: String?
}

struct CurrentSeason: Decodable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int
}
