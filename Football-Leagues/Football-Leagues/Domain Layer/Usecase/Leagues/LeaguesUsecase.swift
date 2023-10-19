//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

protocol LeaguesUsecaseProtocol{
    func fetchLeagues() -> Single<Result<LeagueDataModel,Error>>
//    func fetchTeams() -> Single<Result<LeagueDataModel,Error>>
//    func fetchGames() -> Single<Result<LeagueDataModel,Error>>
//    func fetchSeasons() -> Single<Result<LeagueDataModel,Error>>
    
}

class LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    
    private var leagueModel:LeagueDataModel?
    private var bag:DisposeBag!
    
    init(leaguesRepo: LeaguesRepoInterface = LeaguesReposiotory()) {
        self.leaguesRepo = leaguesRepo
        bag = DisposeBag()
    }
    
    
    func fetchLeagues() -> Single<Result<LeagueDataModel, Error>> {
        return Single.create { [weak self] single in
            guard let self = self else {return Disposables.create()}
            self.leaguesRepo.fetchLeagues(endPoint: LeaguesEndPoints.getAllLeagues).subscribe(onSuccess: { result in
                switch result{
                    case .success(let model):
                        self.leagueModel = model
                    case .failure(let error):
                        print(error)
                }
                single(.success(result))
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
//    func fetchTeams() -> Single<Result<LeagueDataModel, Error>> {
//        return Single.create {[weak self] single in
//            guard let self = self,let competitions = self.leagueModel?.competitions else {return Disposables.create()}
//
//            for index in competitions.indices{
//                if let code = self.leagueModel?.competitions[index].code{
//                    self.leaguesRepo.fetchTeams(endPoint: LeaguesEndPoints.getTeams(code: code)).subscribe(onSuccess: { event in
//                        switch event{
//                            case .success(let model):
//                                self.leagueModel?.competitions[index].numberOfTeams = model.teams?.count
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
//
//    func fetchSeasons() -> Single<Result<LeagueDataModel, Error>> {
//        return Single.create {[weak self] single in
//            guard let self = self,let competitions = self.leagueModel?.competitions else {return Disposables.create()}
//
//            for index in competitions.indices{
//                if let code = self.leagueModel?.competitions[index].code{
//                    self.leaguesRepo.fetchSeasons(endPoint: LeaguesEndPoints.getSeasons(code: code)).subscribe(onSuccess: { event in
//                        switch event{
//                            case .success(let model):
//                                self.leagueModel?.competitions[index].numberOfSeasons = model.seasons?.count
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

