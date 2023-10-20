//
//  LeaguesViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import Foundation
import Combine


// MARK: - View model output protocol
protocol LeaguesViewModelOutputProtocol {
    var progress: AnyPublisher<Bool, Never> { get }
    var showError: AnyPublisher<String, Never> { get }
    var onFinishFetchingLeagues: AnyPublisher<[LeaguesVieweDataModel], Never> { get }
}

struct LeaguesVMOutput: LeaguesViewModelOutputProtocol {
    let progress: AnyPublisher<Bool, Never>
    let showError: AnyPublisher<String, Never>
    let onFinishFetchingLeagues: AnyPublisher<[LeaguesVieweDataModel], Never>
    
    private let progressSubject = PassthroughSubject<Bool,Never>()
    private let showErrorSubject = PassthroughSubject<String, Never>()
    private let onFinishFetchingLeaguesSubject = PassthroughSubject<[LeaguesVieweDataModel], Never>()
    
    init() {
        progress = progressSubject.eraseToAnyPublisher()
        showError = showErrorSubject.eraseToAnyPublisher()
        onFinishFetchingLeagues = onFinishFetchingLeaguesSubject.eraseToAnyPublisher()
    }
    
    func setProgress(_ value: Bool) {
        progressSubject.send(value)
    }
    
    func setError(_ message: String) {
        showErrorSubject.send(message)
    }
    
    func setLeagues(_ leagues: [LeaguesVieweDataModel]) {
        onFinishFetchingLeaguesSubject.send(leagues)
    }
}


protocol LeaguesVMProtocol{
    var input:LeaguesVMInput! {get}
    var outPut:LeaguesVMOutput! {get}
}




// MARK: - View-model
class LeaguesViewModel:LeaguesVMProtocol{
    var input: LeaguesVMInput!
    var outPut: LeaguesVMOutput!
    
    var usecase:LeaguesUsecaseProtocol
    var leagues:[LeaguesVieweDataModel] = []
    
    private var cancellable:Set<AnyCancellable> = []
    
    init(usecase:LeaguesUsecaseProtocol = LeaguesUsecase()) {
        self.input = LeaguesVMInput()
        self.outPut = LeaguesVMOutput()
        self.usecase = usecase
        bind()
    }
    
    private func bind(){
        input.onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
                
            isPullToRefresh ? nil : self.outPut.setProgress(true)
            
            usecase.fetchLeagues().sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        self.outPut.setError(error.localizedDescription)
                }
            } receiveValue: { model in
                
                let newModel = model.competitions.compactMap{
                    LeaguesVieweDataModel(imageUrl: $0.emblem, name: $0.name, code: $0.code, numberOfSeasons: $0.numberOfAvailableSeasons, area: $0.area?.code, type: $0.type)
                }
                self.input.modelCount = newModel.count
                self.input.models = newModel
                self.outPut.setProgress(false)
                self.outPut.setLeagues(newModel)
            }.store(in: &self.cancellable)
            
        }.store(in: &cancellable)
    }
}

