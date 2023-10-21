//
//  LeaguesRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol LeaguesRepoInterface{
    func fetchLeagues(endPoint: EndPoint) -> Future<LeagueDataModel, CustomDomainError>
    func save<T:Codable>(leagues: T,localEntityType:LocalEntityType) -> Future<Bool, Error>
}
class LeaguesReposiotory:LeaguesRepoInterface{
    
    private let appRepo:AppRepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(appRepo: AppRepositoryInterface = AppRepository()) {
        self.appRepo = appRepo
    }
    
    func fetchLeagues(endPoint: EndPoint) -> Future<LeagueDataModel, CustomDomainError> {
        return Future<LeagueDataModel,CustomDomainError> { promise in
            self.appRepo.fetch(endPoint: endPoint, localEntityType: .leagues).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        if let networkError = error as? NetworkError{
                            let customError = CustomDomainError.customError(networkError.localizedDescription)
                            promise(.failure(customError))
                        }else if let coreDataError = error as? CoreDataManager.Errors{
                            let customError = CustomDomainError.customError(coreDataError.localizedDescription)
                            promise(.failure(customError))
                        }
                }
            } receiveValue: { value in
                promise(.success(value))
            }.store(in: &self.cancellables)
        }
    }
    
    func save<T:Codable>(leagues: T,localEntityType:LocalEntityType) -> Future<Bool, Error> {
        return appRepo.save(data: leagues,localEntityType: localEntityType)
    }
}







//Protocol{
    //    func fetchTeams(endPoint:EndPoint) -> Single<Result<TeamsDataModel,Error>>
    //    func fetchSeasons(endPoint:EndPoint) -> Single<Result<SeasonDataModel,Error>>
    //    func fetchMatches(endPoint:EndPoint) -> Single<Result<GamesDataModel,Error>>
//}
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
