//
//  LeagueDetailsViewModelOutput.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsVMOutputProtocol{
    
    var publishableProgress: PassthroughSubject<Bool,Never> {get}
    var publishableError: PassthroughSubject<String,Never> {get}
}

struct LeagueDetailsVMOutput:LeagueDetailsVMOutputProtocol{
    var publishableProgress: PassthroughSubject<Bool, Never>
    var publishableError: PassthroughSubject<String, Never>
    
    var progress: AnyPublisher<Bool,Never>
    var error: AnyPublisher<String,Never>
    init(){
        publishableProgress = PassthroughSubject<Bool,Never>()
        publishableError = PassthroughSubject<String,Never>()
        
        progress = publishableProgress.eraseToAnyPublisher()
        error = publishableError.eraseToAnyPublisher()
    }
}
