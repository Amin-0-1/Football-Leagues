//
//  ErrorDataModel.swift
//  Football-Leagues
//
//  Created by Amin on 23/11/2023.
//

import Foundation

struct ErrorDataModel: Codable {
    let errorCode: Int?
    let message: String?
}
