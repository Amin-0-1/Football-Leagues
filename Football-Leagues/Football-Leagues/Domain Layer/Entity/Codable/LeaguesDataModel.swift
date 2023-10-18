//
//  LeaguesDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

struct LeagueDataModel: Codable {
    let count: Int?
    var competitions: [Competition]
}

struct Competition: Codable {
    let id: Int?
    let area: Area?
    let name, code, type: String?
    let emblem: String?
    let currentSeason: CurrentSeason?
    let numberOfAvailableSeasons: Int?
    let lastUpdated: String?
    
    var numberOfTeams:Int?
    var numberOfGames:Int?
    var numberOfSeasons:Int?
    enum CoodingKeys:String,CodingKey{
        case id
        case are
        case name,code,type
        case emblem
        case currentSeason
        case numberOfAvailableSeasons
        case lastUpdated
    }
}

struct Area: Codable {
    let id: Int?
    let name, code: String?
    let flag: String?
}

struct CurrentSeason: Codable {
    let id: Int?
    let startDate, endDate: String?
    let currentMatchday: Int?
}
