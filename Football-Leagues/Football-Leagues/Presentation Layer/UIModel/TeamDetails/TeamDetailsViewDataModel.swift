//
//  GamesViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

struct TeamDetailsViewDataModel {
    let date: String?
    let status: TeamViewStatus?
    let homeTeam, awayTeam: TeamViewDataModel?
    let winner: TeamViewWinner?
    let score: TeamViewScore?
    
}
struct TeamViewDataModel: Codable {
    let shortName, tla: String?
    let crest: String?
    let clubColors: String?
}
struct TeamViewScore {
    let home: Int?
    let away: Int?
}

enum TeamViewStatus: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}
enum TeamViewWinner: String {
    case away = "AWAY_TEAM"
    case draw = "DRAW"
    case home = "HOME_TEAM"
}
