//
//  TeamViewModelProtocol.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine

protocol TeamViewModelProtocol {
    // MARK: - a view publish
    var onScreenAppeared: PassthroughSubject<Bool, Never> {get}
    var onTapLink: PassthroughSubject<String?, Never> {get}
    var onStaffTapped: PassthroughSubject<Void, Never> {get}
    func getModel(index: Int) -> TeamDetailsViewDataModel
    // MARK: - subscribe
    var showError: AnyPublisher<String, Never> {get}
    var progress: AnyPublisher<Bool, Never> {get}
    var leagueDetails: AnyPublisher<LeagueDetailsViewDataModel, Never> {get}
    var gamesDetails: AnyPublisher<[TeamDetailsViewDataModel], Never> {get}
    var gamesCount: Int {get}
}
class TeamViewModel: TeamViewModelProtocol {
    
    // MARK: - a view model publish
    private var publishError: PassthroughSubject<String, Never> = .init()
    private var publishProgress: PassthroughSubject<Bool, Never> = .init()
    private var publishDetails: PassthroughSubject<LeagueDetailsViewDataModel, Never> = .init()
    private var publishGames: CurrentValueSubject<[TeamDetailsViewDataModel], Never> = .init([])
    @Published var gamesCount: Int
    
    // MARK: - a view can triger these
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    var onTapLink: PassthroughSubject<String?, Never> = .init()
    var onStaffTapped: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - a view binds on these
    var leagueDetails: AnyPublisher<LeagueDetailsViewDataModel, Never>
    var showError: AnyPublisher<String, Never>
    var progress: AnyPublisher<Bool, Never>
    var gamesDetails: AnyPublisher<[TeamDetailsViewDataModel], Never>
    
    var coordinator: GamesCoordinatorProtocol
    var usecase: TeamUsecaseProtcol
    private var headerModel: LeagueDetailsViewDataModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(param: TeamViewModelParam) {
        self.headerModel = param.team
        self.coordinator = param.coordinator
        self.usecase = param.usecase
        self.showError = publishError.eraseToAnyPublisher()
        self.progress = publishProgress.eraseToAnyPublisher()
        self.leagueDetails = publishDetails.eraseToAnyPublisher()
        self.gamesDetails = publishGames.eraseToAnyPublisher()
        gamesCount = 0
        bind()
    }
    private func bind() {
        onScreenAppeared.sink { [weak self] isPullToRefresh in
            guard let self = self else {return}
            self.publishDetails.send(self.headerModel)
            if !isPullToRefresh {
                publishProgress.send(true)
            }
            guard let id = self.headerModel.id else {return}
            usecase.fetchGames(withTeamID: id).sink { completion in
                self.publishProgress.send(false)
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.self.publishError.send(error.localizedDescription)
                }
            } receiveValue: {[weak self] model in
                guard let self = self else {return}
                let viewModels = self.getMappedViewGames(from: model)
                self.gamesCount = viewModels.count
                self.publishGames.send(viewModels)
            }.store(in: &cancellables)

        }.store(in: &cancellables)
        
        onTapLink.sink {[weak self] link in
            guard let self = self else {return}
            guard let link = link, let url = URL(string: link) else {return}
            self.coordinator.navigate(to: url)
        }.store(in: &cancellables)
        
        onStaffTapped.sink { [weak self] _ in
            guard let self = self else {return}
            guard let id = self.headerModel.id else {return}
            coordinator.navigateToStaff(withID: id)
        }.store(in: &cancellables)
    }
    private func getMappedViewGames(from model: TeamDataModel) -> [TeamDetailsViewDataModel] {
        guard let games = model.matches else {return []}
        return games.compactMap { matchModel in
            let status = TeamViewStatus(rawValue: matchModel.status?.rawValue ?? "")
            let home = TeamViewDataModel(
                shortName: matchModel.homeTeam?.shortName,
                tla: matchModel.homeTeam?.tla,
                crest: matchModel.homeTeam?.crest,
                clubColors: matchModel.homeTeam?.clubColors
            )
            let away = TeamViewDataModel(
                shortName: matchModel.awayTeam?.shortName,
                tla: matchModel.awayTeam?.tla,
                crest: matchModel.awayTeam?.crest,
                clubColors: matchModel.awayTeam?.clubColors
            )
            let winner = TeamViewWinner(rawValue: matchModel.score?.winner?.rawValue ?? "")
            let score = TeamViewScore(home: matchModel.score?.fullTime?.home, away: matchModel.score?.fullTime?.away)
            return TeamDetailsViewDataModel(
                date: matchModel.utcDate.convertUTCStringToDate(),
                status: status,
                homeTeam: home,
                awayTeam: away,
                winner: winner,
                score: score)
        }
    }
    func getModel(index: Int) -> TeamDetailsViewDataModel {
        return publishGames.value[index]
    }
}
