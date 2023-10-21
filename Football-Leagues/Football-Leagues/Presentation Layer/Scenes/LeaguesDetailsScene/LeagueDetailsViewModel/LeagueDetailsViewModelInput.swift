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
    var onTapplingLink: PassthroughSubject<String?, Never> {get}
}
struct LeagueDetailsVMInput:LeagueDetailVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool, Never>
    var onTapplingLink: PassthroughSubject<String?, Never>
    init(){
        onScreenAppeared = PassthroughSubject<Bool, Never>()
        onTapplingLink =  PassthroughSubject<String?, Never>()
    }
}
