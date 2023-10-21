//
//  LeaguesViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import Foundation
import Combine


protocol leaguesViewModelProtocol{
    var input:LeaguesVMInputProtocol! {get}
    var output:LeaguesVMOutputprotocol! {get}
}

// MARK: - View-model
class LeaguesViewModel:leaguesViewModelProtocol{
    var input: LeaguesVMInputProtocol!
    var output: LeaguesVMOutputprotocol!
    
    var usecase:LeaguesUsecaseProtocol
    var coordinator:LeaguesCoordinatorProtocol!
    var leagues:[LeaguesViewDataModel] = []
    
    private var cancellable:Set<AnyCancellable> = []
    
    init(input: LeaguesVMInputProtocol = LeaguesVMInput(),
         output: LeaguesVMOutputprotocol = LeaguesVMOutput(),
         usecase: LeaguesUsecaseProtocol = LeaguesUsecase(),
         coordinator: LeaguesCoordinatorProtocol!) {
        self.input = input
        self.output = output
        self.usecase = usecase
        self.coordinator = coordinator
        bind()
    }

    private func bind(){
        bindOnScreenAppeared()
        bindOnTappedCell()
    }
    
    private func bindOnScreenAppeared(){
        input.onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
            if !isPullToRefresh{
                self.output.publishableProgress.send(true)
            }
            
            usecase.fetchLeagues().sink { completion in
                self.output.publishableProgress.send(false)
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        self.output.publishedShowError.send(error.localizedDescription)
                }
            } receiveValue: { model in
                let newModel = LeaguesViewDataModel(
                                    count:model.count,
                                    models:model.competitions.compactMap{LeagueViewDataModel(imageUrl: $0.emblem, name: $0.name, code: $0.code, numberOfSeasons: $0.numberOfAvailableSeasons, area: $0.area?.code, type: $0.type)})
                self.output.publishableProgress.send(false)
                self.output.publishableLeagues.send(newModel)
            }.store(in: &self.cancellable)
            
        }.store(in: &cancellable)
        
    }
    
    private func bindOnTappedCell(){
        input.onTappedCell.sink { [weak self] index in
            guard let self = self else {return}
            guard let data = output.publishableLeagues.value.models[index].code else {return}
            coordinator?.navigateToDetails(withData: data)
        }.store(in: &cancellable)
    }
}
