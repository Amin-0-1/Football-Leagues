//
//  LeagueviewModelOutput.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine


protocol LeaguesVMOutputprotocol {
    var publishableProgress: PassthroughSubject<Bool,Never> { get }
    var publishedShowError: PassthroughSubject<String,Never> { get }
    var publishableLeagues: CurrentValueSubject<[LeaguesVieweDataModel],Never> { get }
    
    var progress: AnyPublisher<Bool,Never> { get }
    var showError: AnyPublisher<String,Never> { get }
    var leagues: AnyPublisher<[LeaguesVieweDataModel],Never> { get }

}

class LeaguesVMOutput: LeaguesVMOutputprotocol {
    
    var publishableProgress: PassthroughSubject<Bool, Never>
    var publishedShowError: PassthroughSubject<String, Never>
    var publishableLeagues: CurrentValueSubject<[LeaguesVieweDataModel], Never>
    
    var progress: AnyPublisher<Bool, Never>
    var showError: AnyPublisher<String, Never>
    var leagues: AnyPublisher<[LeaguesVieweDataModel], Never>
    
    private var cancellable:Set<AnyCancellable> = []
    
    init(){
        publishableProgress = PassthroughSubject<Bool, Never>()
        publishedShowError = PassthroughSubject<String, Never>()
        publishableLeagues = CurrentValueSubject<[LeaguesVieweDataModel], Never>([])
        
        progress = publishableProgress.eraseToAnyPublisher()
        showError = publishedShowError.eraseToAnyPublisher()
        leagues = publishableLeagues.eraseToAnyPublisher()    
    }
}
