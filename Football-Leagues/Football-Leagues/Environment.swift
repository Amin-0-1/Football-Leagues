//
//  Environment.swift
//  Football-Leagues
//
//  Created by Amin on 29/10/2023.
//

import Foundation
public enum PlistKey {
    case serverURL
    case timeoutInterval
    case connectionProtocol
    
    var value: String {
        switch self {
            case .serverURL:
                return "server_url"
            case .timeoutInterval:
                return "timeout_interval"
            case .connectionProtocol:
                return "protocol"
        }
    }
}
public struct Environment {
    private var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }
    public func get(_ key: PlistKey) -> String {
        switch key {
            case .serverURL:
                guard let baseUrl = infoDict[PlistKey.serverURL.value] as? String else {
                    fatalError("Unable to get environment data with key \(key)")
                }
                return baseUrl
            case .timeoutInterval:
                guard let timeout = infoDict[PlistKey.timeoutInterval.value] as? String else {
                    fatalError("Unable to get environment data with key \(key)")
                }
                return timeout
            case .connectionProtocol:
                guard let urlProtocol = infoDict[PlistKey.connectionProtocol.value] as? String else {
                    fatalError("Unable to get environment data with key \(key)")
                }
                return urlProtocol
        }
    }
}
