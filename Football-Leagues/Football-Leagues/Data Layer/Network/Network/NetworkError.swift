//
//  NetworkError.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
public enum NetworkError: Error,CustomStringConvertible{
    case parametersNil
    case encodingFailed
    case missingURL
    case requestFailed(data: Data)
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure(data: Data)
    case serialized(message:String)
    public var description: String {
        switch self {
            case .parametersNil: return "Parameters were nil."
            case .encodingFailed: return "Parameters encoding failed."
            case .missingURL: return "URL is nil."
            case .requestFailed: return "Request Failed"
            case .invalidData: return "Invalid Data"
            case .responseUnsuccessful: return "Response Unsuccessful"
            case .jsonParsingFailure: return "JSON Parsing Failure"
            case .jsonConversionFailure: return "JSON Conversion Failure"
            case .serialized(let str): return str
        }
    }
    
}
