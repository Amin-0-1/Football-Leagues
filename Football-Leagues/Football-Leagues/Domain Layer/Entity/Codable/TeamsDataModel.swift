//
//  TeamsDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

struct TeamsDataModel: Codable {
    let count: Int?
    let competition: Competition?
    let season: Season?
    let teams: [Team]?
}

struct Team: Codable {
    let area: Area?
    let id: Int?
    let name, shortName, tla: String?
    let crest: String?
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors, venue: String?
    let coach: Coach?
    let lastUpdated: String?
}

struct Coach: Codable {
    let id: Int?
    let firstName, lastName, name, dateOfBirth: String?
    let nationality: String?
}
