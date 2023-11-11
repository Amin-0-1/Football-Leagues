//
//  Environment.swift
//  Football-Leagues
//
//  Created by Amin on 29/10/2023.
//

import Foundation
public enum PlistKey {
    case ServerURL
    case TimeoutInterval
    case ConnectionProtocol
    
    var value:String{
        switch self {
            case .ServerURL:
                return "server_url"
            case .TimeoutInterval:
                return "timeout_interval"
            case .ConnectionProtocol:
                return "protocol"
        }
    }

}
public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    public func get(_ key: PlistKey) -> String {
        switch key {
            case .ServerURL:
                guard let baseUrl = infoDict[PlistKey.ServerURL.value] as? String else {
                    fatalError("Unable to get environment data with key \(key)")
                }
                return baseUrl
            case .TimeoutInterval:
                guard let timeout = infoDict[PlistKey.TimeoutInterval.value] as? String else {
                    fatalError("Unable to get environment data with key \(key)")
                }
                return timeout
            case .ConnectionProtocol:
                guard let urlProtocol = infoDict[PlistKey.ConnectionProtocol.value] as? String else{
                    fatalError("Unable to get environment data with key \(key)")
                }
                return urlProtocol
        }
    }
}
