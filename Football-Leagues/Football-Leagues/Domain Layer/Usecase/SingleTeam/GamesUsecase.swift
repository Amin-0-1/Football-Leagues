//
//  SingleTeamUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation
import Combine

protocol GamesUsecaseProtocol{
    func fetchGames(withTeamID:Int)-> Future<GamesDataModel,CustomDomainError>
}
class GamesUsecase:GamesUsecaseProtocol{
    
    private let gamesRepo:GamesRepositoryProtocol!
    private var cancellables:Set<AnyCancellable> = []
    init(repo: GamesRepositoryProtocol = GamesRepository()) {
        self.gamesRepo = repo
    }
    
    func fetchGames(withTeamID id: Int) -> Future<GamesDataModel, CustomDomainError> {
        
        return Future<GamesDataModel,CustomDomainError>{[weak self] promise in
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
    
    private func save(model:GamesDataModel,localEntityType:LocalEntityType){
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
