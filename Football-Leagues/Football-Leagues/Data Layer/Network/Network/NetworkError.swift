//
//  NetworkError.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
public enum NetworkError: Error{
    
    case noInternetConnection
    case requestFailed
    case timeout
    case encodingFailed
    case invalidResponse
    case decodingFailed
    case invalidURL
    
    
    case serverError(statusCode: Int)
    
    public var localizedDescription: String {
        switch self {
            case .requestFailed:
                return "Network is down.";
            case .invalidResponse:
                return "The operation couldn’t be completed."
            case .decodingFailed:
                return "Decoding issue"
            case .noInternetConnection:
                return "The Internet connection appears to be offline."
            case .timeout:
                return "The request timed out."
            case .serverError(statusCode: let statusCode):
                return "Could not connect to the server, \(statusCode) has found."
            case .encodingFailed:
                return "Unable to encode request data"
            case .invalidURL:
                return "Invalid url for network"
        }
    }
    
}
