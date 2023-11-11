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
    
    var BASE_URL:String{
        return Environment().get(.ConnectionProtocol) .appending("://").appending( Environment().get(.ServerURL) )
    }
    let AUTH_TOKEN = "4860e6fcf225488f8a7988607a85c4da"
    
    let dataModel:String = "Football_Leagues"
    
    lazy var header:[String:String] = {
        return ["X-Auth-Token" : AUTH_TOKEN]
    }()
    
    
}


