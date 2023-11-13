//
//  MatchesDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

struct TeamDataModel: Codable {
    let resultSet: ResultSet?
    let matches: [MatchModel]?
}

struct MatchModel: Codable {
    let area: Area?
    let competition: Competition?
    let id: Int?
    let utcDate: String?
    let status: GameStatus?
    let matchday: Int?
    let group: String?
    let homeTeam, awayTeam: Team?
    let score: Score?
    let referees: [Referee]?
}

struct Referee: Codable {
    let id: Int?
    let name: String?
    let nationality: String?
}
struct Score: Codable {
    let winner: Winner?
    let duration: String?
    let fullTime, halfTime: TimeModel?
}
struct TimeModel: Codable {
    let home, away: Int?
}

enum Winner: String, Codable {
    case awayTeam = "AWAY_TEAM"
    case draw = "DRAW"
    case homeTeam = "HOME_TEAM"
}

enum GameStatus: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}

struct ResultSet: Codable {
    let count: Int?
    let competitions, first, last: String?
    let played, wins, draws, losses: Int?
}
