//
//  LeaguesViewModelProtocols.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import Foundation
import RxSwift

protocol LeaguesVMInputProtocol{
    var onScreenAppeared: PublishSubject<Void>{get}
}
struct LeaguesVMInput:LeaguesVMInputProtocol{
    var onScreenAppeared: PublishSubject<Void>
    
    init() {
        self.onScreenAppeared = PublishSubject<Void>()
    }
}


protocol LeaguesViewModelOutputProtocol{
    
}

struct LeaguesVMOutput:LeaguesViewModelOutputProtocol{
    
}


protocol LeaguesVMProtocol{
    var input:LeaguesVMInput! {get}
    var outPut:LeaguesVMOutput! {get}
}

