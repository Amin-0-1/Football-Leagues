//
//  AppConfiguration.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

class AppConfiguration{
    static var shared:AppConfiguration = AppConfiguration()
    private init(){}
    
    let BASE_URL = "https://api.football-data.org"
    let AUTH_TOKEN = "58183ce3e06e4b23a129be05e1a4b66d"
    
    lazy var header:[String:String] = {
        return ["X-Auth-Token" : AUTH_TOKEN]
    }()
    
}


