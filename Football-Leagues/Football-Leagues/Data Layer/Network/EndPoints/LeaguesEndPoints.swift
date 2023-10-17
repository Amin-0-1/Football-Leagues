//
//  LeaguesEndPoints.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

enum LeaguesEndPoints:CustomStringConvertible{
    case getAllLeagues
    case getSeasons(code:String)
    case getTeams(code:String)
    case getMatches(code:String)
    
    var description: String{
        switch self {
            case .getAllLeagues:
                return "/v4/competitions/"
            case .getSeasons(let code):
                return "/v4/competitions/\(code)/"
            case .getTeams(let code):
                return "/v4/competitions/\(code)/teams"
            case .getMatches(let code):
                return "/v4/competitions/\(code)/matches"
        }
    }
}

extension LeaguesEndPoints:EndPoint{
    var base: String {
        AppConfiguration.shared.BASE_URL
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
    
    var encoding: ParameterEncoding {
        return .URLEncoding
    }
    
    
}

