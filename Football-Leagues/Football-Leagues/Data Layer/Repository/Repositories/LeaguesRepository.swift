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
    func fetchLeagues(endPoint:EndPoint)-> Single<Result<LeagueDataModel,CustomDomainError>>
//    func fetchTeams(endPoint:EndPoint) -> Single<Result<TeamsDataModel,Error>>
//    func fetchSeasons(endPoint:EndPoint) -> Single<Result<SeasonDataModel,Error>>
//    func fetchMatches(endPoint:EndPoint) -> Single<Result<GamesDataModel,Error>>
    
    func save<T:Codable>(leagues:T)
}
struct LeaguesReposiotory:LeaguesRepoInterface{
    
    private let appRepo:AppRepositoryInterface!
    private var bag:DisposeBag
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
        bag = DisposeBag()
    }
    
    func fetchLeagues(endPoint: EndPoint) -> Single<Result<LeagueDataModel, CustomDomainError>> {
        return Single.create { single in
            self.appRepo.fetch(endPoint: endPoint, localFetchType: .Leagues, type: LeagueDataModel.self).subscribe(onSuccess: { event in
                switch event{
                    case .success(let model):
                        single(.success(.success(model)))
                    case .failure(let error):
                        if let networkError = error as? NetworkError{
                            let customError = CustomDomainError.customError(networkError.localizedDescription)
                            single(.success(.failure(customError)))
                        }else if let coreDataError = error as? CoreDataManager.Errors{
                            let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                            single(.success(.failure(customError)))
                        }
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
    
    func save<T:Codable>(leagues: T){
        appRepo.save(data: leagues)
    }
    func fetchLeagues() {
        
    }
}
