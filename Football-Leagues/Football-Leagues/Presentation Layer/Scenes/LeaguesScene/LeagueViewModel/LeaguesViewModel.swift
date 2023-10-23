//
//  LeaguesViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import Foundation
import Combine


protocol LeaguesViewModelProtocol{
    // MARK: - view can invoke
    var onScreenAppeared: PassthroughSubject<Bool,Never> {get}
    var onTappedCell: PassthroughSubject<Int,Never> {get}
    func getMode(forIndex:Int)->LeagueViewDataModel
    
    // MARK: - view can bind
    var progress: AnyPublisher<Bool,Never> { get }
    var showError: AnyPublisher<String,Never> { get }
    var leagues: AnyPublisher<LeaguesViewDataModel,Never> {get}
    var leagueCount:Int {get}
}


// MARK: - View-model
class LeaguesViewModel:LeaguesViewModelProtocol{
    
    // MARK: - view model can bind
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    var onTappedCell: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - view can bind
    @Published var leagueCount: Int = 0
    var progress: AnyPublisher<Bool, Never>{
        publishProgress.eraseToAnyPublisher()
    }
    var showError: AnyPublisher<String, Never>{
        publishError.eraseToAnyPublisher()
    }
    var leagues: AnyPublisher<LeaguesViewDataModel, Never>{
        publishLeague.eraseToAnyPublisher()
    }
    // MARK: - view model can publish
    private var publishProgress:PassthroughSubject<Bool,Never> = .init()
    private var publishError:PassthroughSubject<String,Never> = .init()
    private var publishLeague:CurrentValueSubject<LeaguesViewDataModel,Never> = .init(.init(count: nil, models: []))
    
    var usecase:LeaguesUsecaseProtocol
    var coordinator:LeaguesCoordinatorProtocol!
    
    private var cancellable:Set<AnyCancellable> = []
    
    init(usecase: LeaguesUsecaseProtocol = LeaguesUsecase(),
         coordinator: LeaguesCoordinatorProtocol!) {
        self.usecase = usecase
        self.coordinator = coordinator
        bind()
    }

    private func bind(){
        bindOnScreenAppeared()
        bindOnTappedCell()
    }
    
    private func bindOnScreenAppeared(){
        onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
            if !isPullToRefresh{
                self.publishProgress.send(true)
            }
            
            usecase.fetchLeagues().sink { completion in
                self.publishProgress.send(false)
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        self.publishError.send(error.localizedDescription)
                }
            } receiveValue: { model in
                let newModel = LeaguesViewDataModel(
                                    count:model.count,
                                    models:model.competitions.compactMap{LeagueViewDataModel(imageUrl: $0.emblem, name: $0.name, code: $0.code, numberOfSeasons: $0.numberOfAvailableSeasons, area: $0.area?.code, type: $0.type)})
                self.publishProgress.send(false)
                self.leagueCount = newModel.count ?? newModel.models.count
                self.publishLeague.send(newModel)
            }.store(in: &self.cancellable)
            
        }.store(in: &cancellable)
        
    }
    
    private func bindOnTappedCell(){
        onTappedCell.sink { [weak self] index in
            guard let self = self else {return}
            guard let data = publishLeague.value.models[index].code else {return}
            coordinator?.navigateToDetails(withData: data)
        }.store(in: &cancellable)
    }
    
    func getMode(forIndex index: Int) -> LeagueViewDataModel {
        let model = publishLeague.value.models[index]
        return model
    }
}

