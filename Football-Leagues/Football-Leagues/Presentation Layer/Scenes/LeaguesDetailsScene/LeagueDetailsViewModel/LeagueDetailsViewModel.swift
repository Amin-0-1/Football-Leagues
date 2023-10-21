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
    
    private var coordinator:LeagueDetailsCoordinatorProtocol
    private var usecase:LeagueDetailsUsecaseProtocol
    
    private var code:String
    private var cancellables:Set<AnyCancellable> = []
    
    init(params:LeaguesViewModelParams) {
        self.input = params.input
        self.output = params.output
        self.coordinator = params.coordinator
        self.usecase = params.usecase
        self.code = params.code
        bind()
    }

    private func bind(){
        bindOnScreenAppeared()
    }
    
    private func bindOnScreenAppeared(){
        input.onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
            if !isPullToRefresh{
                self.output.publishableProgress.send(true)
            }
            self.usecase.fetchTeams(withData: self.code).sink { completion in
                self.output.publishableProgress.send(false)
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        self.output.publishableError.send(error.localizedDescription)
                }
            } receiveValue: { model in
                self.handleData(withModel: model)
            }.store(in: &cancellables)

        }.store(in: &cancellables)
    }
    
    private func handleData(withModel model:TeamsDataModel){
        var header:LeagueViewDataModel? = nil
        
        if let league = model.competition{
            header = LeagueViewDataModel(imageUrl: league.emblem, name: league.name, code: league.code, numberOfSeasons: league.numberOfAvailableSeasons, area: league.area?.code, type: league.type)
        }
        let newModel = LeaguesDetailsViewDataModel(header: header, countOfTeams: model.count,
                                                   models: model.teams?.compactMap{LeagueDetailsViewDataModel(image: $0.crest, name: $0.shortName, shortName: $0.tla, colors: splitColors($0.clubColors), link: $0.website, stadium: $0.venue, address: $0.address, foundation: $0.founded?.description)} ?? [])

        output.publishableTeams.send(newModel)
    }
    
    private func splitColors(_ input: String?) -> [String] {
        guard let input = input else {return []}
        return input
            .split(separator: "/")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

}

