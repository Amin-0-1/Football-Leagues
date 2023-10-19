//
//  CustomDomainError.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

enum CustomDomainError{
    case connection
    case serverError
    case customError(String)
}

extension CustomDomainError:Error,CustomStringConvertible{
    var description: String{
        switch self {
            case .serverError:
                return "Server Error"
            case .connection:
                return "An Error Occured, Please try again later!"
            case .customError(let string):
                return string
        }
    }
}
