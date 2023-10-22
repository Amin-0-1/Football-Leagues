//
//  SingleTeamViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine


protocol gamesViewModelProtocol{
    var showError : AnyPublisher<String,Never> {get}
    var progress : AnyPublisher<Bool,Never> {get}
    var leagueDetails: AnyPublisher<LeagueDetailsViewDataModel,Never> {get}
    var gamesDetails: AnyPublisher<[GamesViewDataModel],Never> {get}
    var onScreenAppeared:PassthroughSubject<Bool,Never> {get}
    var gamesCount:Int {get}
    func getModel(index:Int)->GamesViewDataModel
}
class GamesViewModel:gamesViewModelProtocol{
    
    // MARK: - a view model publish with these
    private var publishError: PassthroughSubject<String,Never> = .init()
    private var publishProgress: PassthroughSubject<Bool,Never> = .init()
    private var publishDetails : PassthroughSubject<LeagueDetailsViewDataModel,Never> = .init()
    private var publishGames: CurrentValueSubject<[GamesViewDataModel],Never> = .init([])
    
    @Published var gamesCount: Int
    // MARK: - a view can triger these
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    
    // MARK: - a view binds on these
    var leagueDetails: AnyPublisher<LeagueDetailsViewDataModel, Never>
    var showError : AnyPublisher<String,Never>
    var progress: AnyPublisher<Bool, Never>
    var gamesDetails: AnyPublisher<[GamesViewDataModel], Never>
    
    var coordinator:GamesCoordinatorProtocol!
    var usecase:GamesUsecaseProtocol!
    private var headerModel : LeagueDetailsViewDataModel!
    private var cancellables:Set<AnyCancellable> = []
    
    init(param:TeamViewModelParam) {
        self.headerModel =  param.team
        self.coordinator = param.coordinator
        self.usecase = param.usecase 
        self.showError = publishError.eraseToAnyPublisher()
        self.progress = publishProgress.eraseToAnyPublisher()
        self.leagueDetails = publishDetails.eraseToAnyPublisher()
        self.gamesDetails = publishGames.eraseToAnyPublisher()
        gamesCount = 0
        bind()
    }
    private func bind(){
        onScreenAppeared.sink { [weak self] isPullToRefresh in
            guard let self = self else {return}
            self.publishDetails.send(self.headerModel)
            if !isPullToRefresh{
                publishProgress.send(true)
            }
            guard let id = self.headerModel.id else {return}
            usecase.fetchGames(withTeamID: id).sink { completion in
                self.publishProgress.send(false)
                switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        self.self.publishError.send(error.localizedDescription)
                }
            } receiveValue: { model in
                let viewModels = self.getMappedViewGames(from: model)
                self.gamesCount = viewModels.count
                self.publishGames.send(viewModels)
            }.store(in: &cancellables)

        }.store(in: &cancellables)
    }
    private func getMappedViewGames(from model:GamesDataModel) -> [GamesViewDataModel]{
        guard let games = model.matches else {return []}
        return games.compactMap{ matchModel in
            let status = GameViewStatus(rawValue: matchModel.status?.rawValue ?? "")
            let home = GameViewTeam(shortName: matchModel.homeTeam?.shortName, tla: matchModel.homeTeam?.tla, crest: matchModel.homeTeam?.crest, clubColors: matchModel.homeTeam?.clubColors)
            let away = GameViewTeam(shortName: matchModel.awayTeam?.shortName, tla: matchModel.awayTeam?.tla, crest: matchModel.awayTeam?.crest, clubColors: matchModel.awayTeam?.clubColors)
            let winner = GameViewWinner(rawValue: matchModel.score?.winner?.rawValue ?? "")
            let score = GameViewScore(home: matchModel.score?.fullTime?.home, away: matchModel.score?.fullTime?.away)
            return GamesViewDataModel(date: matchModel.utcDate.convertUTCStringToDate(), status: status, homeTeam: home, awayTeam: away,winner: winner,score: score)
        }
    }
    func getModel(index: Int) -> GamesViewDataModel {
        return publishGames.value[index]
    }
}
