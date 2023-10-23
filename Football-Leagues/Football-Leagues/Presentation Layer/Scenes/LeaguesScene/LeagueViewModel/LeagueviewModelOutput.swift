//
//  LeagueviewModelOutput.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine


//protocol LeaguesVMOutputprotocol {
//    var publishableProgress: PassthroughSubject<Bool,Never> { get }
//    var publishedShowError: PassthroughSubject<String,Never> { get }
//    var publishableLeagues: CurrentValueSubject<LeaguesViewDataModel,Never> { get }
//    
//    var progress: AnyPublisher<Bool,Never> { get }
//    var showError: AnyPublisher<String,Never> { get }
//    var leagues: AnyPublisher<LeaguesViewDataModel,Never> { get }
//
//}
//
//class LeaguesVMOutput: LeaguesVMOutputprotocol {
//    
//    var publishableProgress: PassthroughSubject<Bool, Never>
//    var publishedShowError: PassthroughSubject<String, Never>
//    var publishableLeagues: CurrentValueSubject<LeaguesViewDataModel, Never>
//    
//    var progress: AnyPublisher<Bool, Never>
//    var showError: AnyPublisher<String, Never>
//    var leagues: AnyPublisher<LeaguesViewDataModel, Never>
//    
//    private var cancellable:Set<AnyCancellable> = []
//    
//    init(){
//        publishableProgress = PassthroughSubject<Bool, Never>()
//        publishedShowError = PassthroughSubject<String, Never>()
//        publishableLeagues = CurrentValueSubject<LeaguesViewDataModel, Never>(.init(count: 0, models: []))
//        
//        progress = publishableProgress.eraseToAnyPublisher()
//        showError = publishedShowError.eraseToAnyPublisher()
//        leagues = publishableLeagues.eraseToAnyPublisher()    
//    }
//}
