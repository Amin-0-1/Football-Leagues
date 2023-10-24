//
//  CustomDomainError.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

enum CustomDomainError{
    case connectionError
    case serverError
    case customError(String)
}

extension CustomDomainError:Error{
    var localizedDescription: String{
        switch self {
            case .serverError:
                return "Server Error"
            case .connectionError:
                return "An Error Occured, no internet connection, try again later"
            case .customError(let string):
                return string
        }
    }
}
