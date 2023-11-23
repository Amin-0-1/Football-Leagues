//
//  StaffDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 23/11/2023.
//

import Foundation

// MARK: - StaffDataModel
struct StaffDataModel: Codable {
    let area: Area?
    let id: Int?
    let name, shortName, tla: String?
    let crest: String?
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors, venue: String?
    let runningCompetitions: [RunningCompetition]?
    let coach: Coach?
    let squad: [Squad]?
    let lastUpdated: String?
}

// MARK: - Coach
struct Coach: Codable {
    let id: Int?
    let firstName, lastName, name, dateOfBirth: String?
    let nationality: String?
    let contract: Contract?
}

// MARK: - Contract
struct Contract: Codable {
    let start, until: String?
}

// MARK: - RunningCompetition
struct RunningCompetition: Codable {
    let id: Int?
    let name, code, type: String?
    let emblem: String?
}

// MARK: - Squad
struct Squad: Codable {
    let id: Int?
    let name: String?
    let position: String?
    let dateOfBirth, nationality: String?
}

enum Position: String, Codable {
    case goalkeeper = "Goalkeeper"
    case defence = "Defence"
    case midfield = "Midfield"
    case offence = "Offence"
}
