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
    var onTappingLink: PassthroughSubject<String?, Never> {get}
    var onTappingCell: PassthroughSubject<Int,Never>{get}
}
struct LeagueDetailsVMInput:LeagueDetailVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool, Never>
    var onTappingLink: PassthroughSubject<String?, Never>
    var onTappingCell: PassthroughSubject<Int, Never>
    init(){
        onScreenAppeared = PassthroughSubject<Bool, Never>()
        onTappingLink =  PassthroughSubject<String?, Never>()
        onTappingCell = PassthroughSubject<Int,Never>()
    }
}
