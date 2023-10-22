//
//  GamesViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

struct GamesViewDataModel{
    let date: String?
    let status: GameViewStatus?
    let homeTeam,awayTeam: GameViewTeam?
    let winner:GameViewWinner?
    let score:GameViewScore?
    
}
struct GameViewTeam: Codable {
    let shortName, tla: String?
    let crest: String?
    let clubColors:String?
}
struct GameViewScore{
    let home:Int?
    let away:Int?
}

enum GameViewStatus: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}
enum GameViewWinner:String{
    case away = "AWAY_TEAM"
    case draw = "DRAW"
    case home = "HOME_TEAM"
}
