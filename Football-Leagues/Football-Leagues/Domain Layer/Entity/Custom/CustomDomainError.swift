//
//  CustomDomainError.swift
//  Football-Leagues
//
//  Created by Amin on 18/10/2023.
//

import Foundation

enum CustomDomainError{
    case error(String)
}

extension CustomDomainError:Error,CustomStringConvertible{
    var description: String{
        switch self {
            case .error(let string):
                return string
        }
    }
}
