//
//  LeaguesEndPoints.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

enum LeaguesEndPoints: CustomStringConvertible {
    case getAllLeagues
    case getTeams(code: String)
    case getGames(id: Int)
    
    var description: String {
        switch self {
            case .getAllLeagues:
                return "/v4/competitions/"
            case .getTeams(let code):
                return "/v4/competitions/\(code)/teams"
            case .getGames(let id):
                return "/v4/teams/\(id)/matches"
        }
    }
    var code: String? {
        switch self {
            case .getAllLeagues:
                return nil
            case .getTeams(let code):
                return code
            case .getGames(let id):
                return id.description
        }
    }
}

extension LeaguesEndPoints: EndPoint {
    var base: String {
        AppConfiguration.shared.baseUrl
    }
    
    var path: String {
        return self.description
    }
    
    var header: HTTPHeaders? {
        return AppConfiguration.shared.header
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var method: HTTPMethods {
        return .get
    }
    
    var encoding: Encoding {
        switch self {
            case .getAllLeagues:
                return .JSONEncoding
            case .getTeams:
                return .URLEncoding
            case .getGames:
                return .URLEncoding
        }
    }
}
