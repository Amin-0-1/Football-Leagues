//
//  SingleTeamViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine


protocol SingleTeamViewModelProtocol{
    var showError : AnyPublisher<Bool,Never> {get}
    var progress : AnyPublisher<Bool,Never> {get}
    
    var onScreenAppeared:PassthroughSubject<Bool,Never> {get}
}
class SingleTeamViewModel:SingleTeamViewModelProtocol{

    private var publishError: PassthroughSubject<Bool,Never> = .init()
    private var publishProgress: PassthroughSubject<Bool,Never> = .init()
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    
    var showError : AnyPublisher<Bool,Never>
    var progress: AnyPublisher<Bool, Never>
    
    var coordinator:SingleTeamCoordinator!
    var usecase:SingleTeamUsecaseProtocol!
    
    init(coordinator: SingleTeamCoordinator,
         usecase: SingleTeamUsecaseProtocol = SignleTeamUsecase()) {
        
        self.showError = publishError.eraseToAnyPublisher()
        self.progress = publishProgress.eraseToAnyPublisher()
        bind()
    }
    private func bind(){
        
    }
}
