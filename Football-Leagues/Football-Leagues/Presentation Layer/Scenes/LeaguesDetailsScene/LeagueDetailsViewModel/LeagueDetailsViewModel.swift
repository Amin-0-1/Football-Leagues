//
//  LeagueDetailsViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 20/10/2023.
//

import Foundation
import Combine

protocol LeagueDetailsViewModelProtocol {
    
    // MARK: - view can trigger or bind these
    var onScreenAppeared: PassthroughSubject<Bool, Never> {get}
    var onTappingLink: PassthroughSubject<String?, Never> {get}
    var onTappingCell: PassthroughSubject<Int, Never> {get}
    var teams: AnyPublisher<LeaguesDetailsViewDataModel, Never> {get}
    func getModel(index: Int) -> LeagueDetailsViewDataModel
    
    // MARK: - view binds on these
    var showError: AnyPublisher<String, Never> {get}
    var progress: AnyPublisher<Bool, Never> {get}
    var modelCount: Int {get}
    
}
class LeagueDetailsViewModel: LeagueDetailsViewModelProtocol {
    // MARK: - view model binds on these
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    var onTappingLink: PassthroughSubject<String?, Never> = .init()
    var onTappingCell: PassthroughSubject<Int, Never> = .init()
    var teams: AnyPublisher<LeaguesDetailsViewDataModel, Never> {
        publishableTeams.eraseToAnyPublisher()
    }
    @Published var modelCount: Int = 0
    
    var showError: AnyPublisher<String, Never> {
        publishError.eraseToAnyPublisher()
    }
    var progress: AnyPublisher<Bool, Never> {
        publishProgress.eraseToAnyPublisher()
    }
    private var publishError: PassthroughSubject<String, Never> = .init()
    private var publishProgress: PassthroughSubject<Bool, Never> = .init()
    var publishableTeams: CurrentValueSubject<LeaguesDetailsViewDataModel, Never> = .init(.init(models: []))
    
    private var coordinator: LeagueDetailsCoordinatorProtocol
    private var usecase: LeagueDetailsUsecaseProtocol
    
    private var code: String
    private var cancellables: Set<AnyCancellable> = []
    
    init(params: LeaguesViewModelParams) {
        self.coordinator = params.coordinator
        self.usecase = params.usecase
        self.code = params.code
        bind()
    }

    private func bind() {
        bindOnScreenAppeared()
        bindOnTapLink()
        bindOnTapCell()
    }
    
    private func bindOnScreenAppeared() {
        onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
            if !isPullToRefresh {
                self.publishProgress.send(true)
            }
            self.usecase.fetchTeams(withData: self.code).sink { completion in
                self.publishProgress.send(false)
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.publishError.send(error.localizedDescription)
                }
            } receiveValue: { model in
                self.handleData(withModel: model)
            }.store(in: &cancellables)

        }.store(in: &cancellables)
    }
    private func bindOnTapLink() {
        onTappingLink.sink { [weak self] link in
            guard let self = self else {return}
            guard let link = link, let url = URL(string: link) else {
                publishError.send("Cannot open this page right now, please try again later!")
                return
            }
            self.coordinator.navigateToWebView(withLink: url)
        }.store(in: &cancellables)
    }
    private func bindOnTapCell() {
        onTappingCell.sink { [weak self] index in
            guard let self = self else {return}
            let team = self.publishableTeams.value.models[index]
            self.coordinator.navigateTo(team: team)
        }.store(in: &cancellables)
    }
    private func handleData(withModel model: LeagueDetailsDataModel) {
        var header: LeagueViewDataModel?
        
        if let league = model.competition {
            header = LeagueViewDataModel(
                imageUrl: league.emblem,
                name: league.name,
                code: league.code,
                numberOfSeasons: league.numberOfAvailableSeasons,
                area: league.area?.code,
                type: league.type
            )
        }
        let newModel = LeaguesDetailsViewDataModel(
            header: header,
            countOfTeams: model.count,
            models: model.teams?.compactMap {
                LeagueDetailsViewDataModel(
                    id: $0.id,
                    image: $0.crest,
                    name: $0.shortName,
                    shortName: $0.tla,
                    colors: splitColors($0.clubColors),
                    link: $0.website,
                    stadium: $0.venue,
                    address: $0.address,
                    foundation: $0.founded?.description
                )
            } ?? []
        )

        self.modelCount = newModel.countOfTeams ?? newModel.models.count
        publishableTeams.send(newModel)
    }
    
    func getModel(index: Int) -> LeagueDetailsViewDataModel {
        let model = publishableTeams.value.models[index]
        return model
    }
    
    private func splitColors(_ input: String?) -> [String] {
        guard let input = input else {return []}
        return input
            .split(separator: "/")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

}
