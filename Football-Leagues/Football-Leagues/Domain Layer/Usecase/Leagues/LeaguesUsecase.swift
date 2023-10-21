//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol LeaguesUsecaseProtocol{
    func fetchLeagues() -> Future<LeagueDataModel,CustomDomainError>
//    func fetchTeams() -> Single<Result<LeagueDataModel,Error>>
//    func fetchGames() -> Single<Result<LeagueDataModel,Error>>
//    func fetchSeasons() -> Single<Result<LeagueDataModel,Error>>
    
}

class LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(leaguesRepo: LeaguesRepoInterface = LeaguesReposiotory()) {
        self.leaguesRepo = leaguesRepo
    }
    
    
    func fetchLeagues() -> Future<LeagueDataModel, CustomDomainError> {
        return Future<LeagueDataModel,CustomDomainError> { promise in
            self.leaguesRepo.fetchLeagues(endPoint: LeaguesEndPoints.getAllLeagues).sink { completion in
                switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error))
                }
            } receiveValue: { model in
                self.save(leagues: model,localEntityType: .leagues)
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }

    private func save(leagues:LeagueDataModel,localEntityType:LocalEntityType){
        leaguesRepo.save(leagues: leagues,localEntityType: .leagues).sink { _ in } receiveValue: { isSaved in
            print(isSaved)
        }.store(in: &cancellables)

    }
    
//
//    func fetchGames() -> Single<Result<LeagueDataModel, Error>> {
//        return Single.create {[weak self] single in
//            guard let self = self,let competitions = self.leagueModel?.competitions else {return Disposables.create()}
//
//            for index in competitions.indices{
//                if let code = self.leagueModel?.competitions[index].code{
//                    self.leaguesRepo.fetchMatches(endPoint: LeaguesEndPoints.getMatches(code: code)).subscribe(onSuccess: { event in
//                        switch event{
//                            case .success(let model):
//                                self.leagueModel?.competitions[index].numberOfGames = model.matches?.count
//                                single(.success(.success(self.leagueModel!)))
//                            case .failure(let error):
//                                print(error.localizedDescription)
//                        }
//                    }).disposed(by: bag)
//                }
//            }
//            return Disposables.create()
//        }
//    }
}

