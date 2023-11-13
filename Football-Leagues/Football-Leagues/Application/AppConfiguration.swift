//
//  AppConfiguration.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

class AppConfiguration {
    static var shared = AppConfiguration()
    private init() {}
    
    var baseUrl: String {
        return Environment().get(.connectionProtocol) .appending(": //").appending( Environment().get(.serverURL) )
    }
    let authToken = "4860e6fcf225488f8a7988607a85c4da"
    
    let dataModel: String = "Football_Leagues"
    
    lazy var header: [String: String] = {
        return ["X-Auth-Token": authToken]
    }()
}
