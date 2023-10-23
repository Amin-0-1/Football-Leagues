//
//  LocalFetchType.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation

enum LocalEndPoint{
    case leagues
    case teams(code:String)
    case games(id:Int)
}
