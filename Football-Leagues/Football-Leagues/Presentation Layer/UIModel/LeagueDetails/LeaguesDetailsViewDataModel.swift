//
//  LeaguesDetailsViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import Foundation

struct LeaguesDetailsViewDataModel{
    var header: LeagueViewDataModel?
    var countOfTeams: Int?
    var models: [LeagueDetailsViewDataModel]
}
struct LeagueDetailsViewDataModel{
    let image:String?
    let name:String?
    let shortName:String?
    let colors:String?
    let link:String?
    let stadium:String?
    let address:String?
    let foundation:String?
}
