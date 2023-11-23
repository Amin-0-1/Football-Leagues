//
//  StaffViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import Foundation
import Combine

protocol StaffViewModelProtocol {
    var onScreenAppeared: PassthroughSubject<Void, Never> {get}
    
    var error: AnyPublisher<String, Never> {get}
    var progress: AnyPublisher<Bool, Never> {get}
    var onFinishFetching: AnyPublisher<Void, Never> {get}
    var title: AnyPublisher<String, Never> {get}
    var staffCount: Int {get}
    func getModel(forIndex: Int) -> StaffViewDataModel?
}

class StaffViewModel: StaffViewModelProtocol {
    var onScreenAppeared: PassthroughSubject<Void, Never> = .init()
    
    private var errorPublisher: PassthroughSubject<String, Never> = .init()
    private var progressPublisher: PassthroughSubject<Bool, Never> = .init()
    private var onFinishFetchingPublisher: PassthroughSubject<Void, Never> = .init()
    private var titlePublisher: PassthroughSubject<String, Never> = .init()
    
    var error: AnyPublisher<String, Never> {
        return errorPublisher.eraseToAnyPublisher()
    }
    var progress: AnyPublisher<Bool, Never> {
        return progressPublisher.eraseToAnyPublisher()
    }
    
    var onFinishFetching: AnyPublisher<Void, Never> {
        return onFinishFetchingPublisher.eraseToAnyPublisher()
    }
    
    var title: AnyPublisher<String, Never> {
        return titlePublisher.eraseToAnyPublisher()
    }
    
    @Published var staffCount: Int
    private var teamID: Int
    private var staff: StaffDataModel?
    private var coordinator: StaffCoordinatorProtocol
    private var usecase: StaffUsecaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    init(
        coordinator: StaffCoordinatorProtocol,
        usecase: StaffUsecaseProtocol = StaffUsecase(),
        teamID: Int
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
        self.teamID = teamID
        staffCount = 0
        bind()
    }
    private func bind() {
        onScreenAppeared.sink { [weak self] _ in
            guard let self = self else {return}
            usecase.fetchStaff(withTeamID: self.teamID).sink { completion in
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.errorPublisher.send(error.localizedDescription)
                        
                }
            } receiveValue: { model in
                self.staff = model
                self.staffCount = model.squad?.count ?? 0
                let title = model.name?.appending(" players") ?? "Players"
                self.titlePublisher.send(title)
                self.onFinishFetchingPublisher.send()
            }.store(in: &cancellables)

        }.store(in: &cancellables)
    }
    func getModel(forIndex index: Int) -> StaffViewDataModel? {
        guard let staff = staff, let squads = staff.squad else {return nil}
        let squad = squads[index]
        
        let model = StaffViewDataModel(
            name: squad.name,
            position: squad.position,
            nationality: squad.nationality,
            clubImageURL: staff.crest
        )
        return model
    }
}
