//
//  LeagueDetailsViewModelInput.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailVMInputProtocol{
    var onScreenAppeared:PassthroughSubject<Bool,Never> {get}
}
struct LeagueDetailsVMInput:LeagueDetailVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool, Never>
    init(){
        onScreenAppeared = PassthroughSubject<Bool, Never>()
    }
}
