//
//  LeaguesViewDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

class LeaguesVieweDataModel{
    
    let imageUrl: String?
    let name: String?
    let code: String?
    let numberOfSeasons: Int?
    let area:String?
    let type:String?
    
    init(imageUrl: String?, name: String?, code: String?, numberOfSeasons: Int?, area: String?, type: String?) {
        self.imageUrl = imageUrl
        self.name = name
        self.code = code
        self.numberOfSeasons = numberOfSeasons
        self.area = area
        self.type = type
    }
}
