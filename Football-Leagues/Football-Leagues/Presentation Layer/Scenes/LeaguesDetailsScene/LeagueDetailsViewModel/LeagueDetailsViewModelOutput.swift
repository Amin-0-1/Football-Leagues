//
//  LeagueDetailsViewModelOutput.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsVMOutputProtocol{
    var publishableTeams : CurrentValueSubject<LeaguesDetailsViewDataModel,Never> {get}
    var publishableProgress: PassthroughSubject<Bool,Never> {get}
    var publishableError: PassthroughSubject<String,Never> {get}
}

struct LeagueDetailsVMOutput:LeagueDetailsVMOutputProtocol{
    var publishableTeams : CurrentValueSubject<LeaguesDetailsViewDataModel,Never>
    var publishableProgress: PassthroughSubject<Bool, Never>
    var publishableError: PassthroughSubject<String, Never>
    
    var progress: AnyPublisher<Bool,Never>
    var error: AnyPublisher<String,Never>
    
    init(){
        publishableProgress = PassthroughSubject<Bool,Never>()
        publishableError = PassthroughSubject<String,Never>()
        publishableTeams = CurrentValueSubject<LeaguesDetailsViewDataModel,Never>(.init(models: []))
        progress = publishableProgress.eraseToAnyPublisher()
        error = publishableError.eraseToAnyPublisher()
    }
}
