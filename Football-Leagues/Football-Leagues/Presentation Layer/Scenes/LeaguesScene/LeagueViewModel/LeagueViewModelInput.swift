//
//  LeagueViewModelInput.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeaguesVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool,Never> {get}
    var onTappedCell: PassthroughSubject<Int,Never> {get}
    
}
struct LeaguesVMInput:LeaguesVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool,Never>
    var onTappedCell: PassthroughSubject<Int,Never>
    
    init() {
        self.onScreenAppeared = PassthroughSubject<Bool,Never>()
        self.onTappedCell = PassthroughSubject<Int,Never>()
        
    }
}
