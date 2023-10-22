////
////  MatchesDataModel.swift
////  Football-Leagues
////
////  Created by Amin on 18/10/2023.
////
//
//import Foundation
//
//struct GamesDataModel: Codable {
//    let competition: Competition?
//    let matches: [Game]?
//}
//struct Game: Codable {
//    let area: Area?
//    let competition: Competition?
//    let season: Season?
//    let id: Int?
//    let utcDate: String?
//    let status: String?
//    let matchday: Int?
//    let stage: String?
//    let lastUpdated: String?
//    let homeTeam, awayTeam: Team?
//    let score: Score?
//}
//struct Score: Codable {
//    let winner: WinnerState?
//    let duration: String?
//    let fullTime, halfTime: MatchState?
//}
//
//enum WinnerState: String, Codable {
//    case awayTeam = "AWAY_TEAM"
//    case draw = "DRAW"
//    case homeTeam = "HOME_TEAM"
//}
//
//struct MatchState:Codable{
//    let home:Int?
//    let away:Int?
//}
//
