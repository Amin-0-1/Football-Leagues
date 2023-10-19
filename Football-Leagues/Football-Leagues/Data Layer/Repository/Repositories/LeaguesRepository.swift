//
//  LeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol LeaguesRepoInterface{
    func fetchLeagues(endPoint:EndPoint)-> Single<Result<LeagueDataModel,Error>>
//    func fetchTeams(endPoint:EndPoint) -> Single<Result<TeamsDataModel,Error>>
//    func fetchSeasons(endPoint:EndPoint) -> Single<Result<SeasonDataModel,Error>>
//    func fetchMatches(endPoint:EndPoint) -> Single<Result<GamesDataModel,Error>>
    
    func saveLeagues(leagues:[Competition])
    func fetchLeagues()
}
struct LeaguesReposiotory:LeaguesRepoInterface{
    
    private let appRepo:AppRepositoryInterface!
    private var bag:DisposeBag
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
        bag = DisposeBag()
    }
    
    func fetchLeagues(endPoint: EndPoint) -> Single<Result<LeagueDataModel, Error>> {
        return Single.create { single in
            self.appRepo.fetch(endPoint: endPoint, type: LeagueDataModel.self).subscribe(onSuccess: { event in
                switch event{
                    case .success(let model):
                        single(.success(.success(model)))
                    case .failure(let error):
                        let customError = NSError(domain: error.localizedDescription, code: 0)
                        single(.success(.failure(customError)))
                }
            }).disposed(by: self.bag)
            
            return Disposables.create()
        }
    }
//    func fetchTeams(endPoint: EndPoint) -> Single<Result<TeamsDataModel, Error>> {
//        return Single.create { single in
//            self.appRepo.fetch(endPoint: endPoint, type: TeamsDataModel.self).subscribe(onSuccess: { event in
//                switch event{
//                    case .success(let model):
//                        single(.success(.success(model)))
//                    case .failure(let error):
//                        let customError = NSError(domain: error.localizedDescription, code: 0)
//                        single(.success(.failure(customError)))
//                }
//            }).disposed(by: bag)
//
//            return Disposables.create()
//        }
//    }
//
//    func fetchSeasons(endPoint: EndPoint) -> Single<Result<SeasonDataModel, Error>> {
//        return Single.create { single in
//            self.appRepo.fetch(endPoint: endPoint, type: SeasonDataModel.self).subscribe(onSuccess: { event in
//                switch event{
//                    case .success(let model):
//                        single(.success(.success(model)))
//                    case .failure(let error):
//                        let customError = NSError(domain: error.localizedDescription, code: 0)
//                        single(.success(.failure(customError)))
//                }
//            }).disposed(by: bag)
//
//            return Disposables.create()
//        }
//    }
//
//    func fetchMatches(endPoint: EndPoint) -> Single<Result<GamesDataModel, Error>> {
//        return Single.create { single in
//            self.appRepo.fetch(endPoint: endPoint, type: GamesDataModel.self).subscribe(onSuccess: { event in
//                switch event{
//                    case .success(let model):
//                        single(.success(.success(model)))
//                    case .failure(let error):
//                        let customError = NSError(domain: error.localizedDescription, code: 0)
//                        single(.success(.failure(customError)))
//                }
//            }).disposed(by: bag)
//
//            return Disposables.create()
//        }
//    }
    
    func saveLeagues(leagues: [Competition]){
        appRepo.save(competitions: leagues)
    }
    func fetchLeagues() {
        
    }
}
