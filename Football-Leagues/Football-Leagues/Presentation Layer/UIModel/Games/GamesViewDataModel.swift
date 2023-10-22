//
//  GamesViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

struct GamesViewDataModel{
    let utcDate: Double?
    let status: GameViewStatus?
    let homeTeam,awayTeam: GameViewTeam?
    
}

enum GameViewStatus: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}

struct GameViewTeam: Codable {
    let shortName, tla: String?
    let crest: String?
    let clubColors:String?
}
