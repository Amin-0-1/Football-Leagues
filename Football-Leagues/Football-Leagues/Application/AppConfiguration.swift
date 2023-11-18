//
//  AppConfiguration.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

class AppConfiguration {
    static var shared = AppConfiguration()
    var env: Environment
    
    private init() {
        env = Environment()
    }
    
    lazy var baseUrl: String = {
        do {
            return try env
                .get(.connectionProtocol)
                .appending("://")
                .appending( env.get(.serverURL) )
        } catch {
            printError(error)
            return ""
        }
    }()
    
    lazy var authToken: String = {
        do {
            return try env.get(.token)
        } catch {
            printError(error)
            return ""
        }
    }()
    
    lazy var dataModel: String = {
        do {
            return try env.get(.localDataModel)
        } catch {
            printError(error)
            return ""
        }
    }()
    
    lazy var header: [String: String] = {
        return ["X-Auth-Token": authToken]
    }()
    
    private func printError(_ error: Error) {
        let separator = "\n**********************\n"
        print(separator, error, separator)
    }
}
