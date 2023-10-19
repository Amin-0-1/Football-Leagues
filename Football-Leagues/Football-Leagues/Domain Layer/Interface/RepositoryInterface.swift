//
//  RepositoryInterface.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift
protocol RepositoryInterface{
    func fetch<T:Codable>(endPoint:EndPoint?,type:T.Type) -> Single<Result<T,Error>>
}

