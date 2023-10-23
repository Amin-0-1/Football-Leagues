//
//  TeamsDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

struct LeagueDetailsDataModel: Codable {
    let count: Int?
    let competition: Competition?
    let teams: [Team]?
}

struct Team: Codable {
    let area: Area?
    let id: Int?
    let shortName, tla: String?
    let crest: String?
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors, venue: String?
    let coach: Coach?
}

struct Area: Codable {
    let id: Int?
    let name: String?
    let code: String?
    let flag: String?
}

struct Coach: Codable {
    let id: Int?
    let firstName, lastName, name, dateOfBirth: String?
    let nationality: String?
}
