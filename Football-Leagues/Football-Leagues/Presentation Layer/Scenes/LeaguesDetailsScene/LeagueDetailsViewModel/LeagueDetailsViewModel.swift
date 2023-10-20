//
//  LeagueDetailsViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine


protocol leagueDetailsVMProtocol{
    var input:LeagueDetailVMInputProtocol! {get}
    var output:LeagueDetailsVMOutputProtocol! {get}
}

class LeagueDetailsViewModel:leagueDetailsVMProtocol{
    var input: LeagueDetailVMInputProtocol!
    var output: LeagueDetailsVMOutputProtocol!
    
    var coordinator:LeagueDetailsCoordinatorProtocol
    var usecase:LeagueDetailsUsecaseProtocol
    private var cancellables:Set<AnyCancellable> = []
    
    init(input: LeagueDetailVMInputProtocol = LeagueDetailsVMInput(),
         output: LeagueDetailsVMOutputProtocol = LeagueDetailsVMOutput(),
         usecase: LeagueDetailsUsecaseProtocol = LeagueDetailsUsecase(),
         coordinator: LeagueDetailsCoordinatorProtocol) {
        self.input = input
        self.output = output
        self.coordinator = coordinator
        self.usecase = usecase
        bind()
    }

    private func bind(){
        bindOnScreenAppeared()
    }
    
    private func bindOnScreenAppeared(){
        input.onScreenAppeared.sink { isPullToRefresh in
            
        }.store(in: &cancellables)
    }
}

