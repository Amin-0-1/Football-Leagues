//
//  SingleTeamUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine

protocol TeamUsecaseProtcol{
    func fetchGames(withTeamID:Int)-> Future<TeamDataModel,CustomDomainError>
}
class TeamUsecase:TeamUsecaseProtcol{
    
    private let gamesRepo:TeamRepositoryProtocol!
    private var cancellables:Set<AnyCancellable> = []
    init(repo: TeamRepositoryProtocol = TeamRepository()) {
        self.gamesRepo = repo
    }
    
    func fetchGames(withTeamID id: Int) -> Future<TeamDataModel, CustomDomainError> {
        
        return Future<TeamDataModel,CustomDomainError>{[weak self] promise in
            guard let self = self else {return}
            gamesRepo.fetchGames(endPoint: LeaguesEndPoints.getGames(id: id), localEntityType: .games(id: id)).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                        print(error)
                }
            } receiveValue: { model in
                self.save(model: model, localEntityType: .games(id: id))
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }
    
    private func save(model:TeamDataModel,localEntityType:LocalEntityType){
        gamesRepo.save(model: model, localEntityType: localEntityType).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
            }
        } receiveValue: { isSaved in
            debugPrint(isSaved)
        }.store(in: &cancellables)
    }
}
