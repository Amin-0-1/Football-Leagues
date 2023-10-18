//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol LeaguesUsecaseProtocol{
    func fetch(completion:@escaping (LeagueDataModel?)->Void)
}

struct LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    private let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", qos: .background, attributes: .concurrent)
    private var group:DispatchGroup!
    init(leaguesRepo: LeaguesRepoInterface) {
        self.leaguesRepo = leaguesRepo
        group = DispatchGroup()
    }
    func fetch(completion:@escaping (LeagueDataModel?)->Void){
        leaguesRepo.fetchLeagues(endPoint: LeaguesEndPoints.getAllLeagues) { result in
            switch result {
                case .success(let model):
                    self.handle(model: model,completions:completion)
                case .failure(let failure):
                    let message = failure.description
                    let error = CustomDomainError.error(message)
//                    completions.leaguesCompletion(.failure(error))
            }
        }
        
    }
    private func handle(model: LeagueDataModel,completions: @escaping (LeagueDataModel?)->Void){
        Task{
            var newModel = model
            for index in model.competitions.indices {
                guard let code = model.competitions[index].code else {return}
                
                let seasons = await fetchSeasons(code:code)
                let teams = await fetchTeams(code: code)
                let matches = await fetchMatches(code: code)
                
                newModel.competitions[index].numberOfSeasons = seasons?.seasons?.count
                newModel.competitions[index].numberOfGames = matches?.matches?.count
                newModel.competitions[index].numberOfTeams = teams?.teams?.count
                
                completions(newModel)
            }
        }
    }
    
    private func fetchSeasons (code:String) async -> SeasonDataModel?{
        do{
            return try await withCheckedThrowingContinuation{ continuation in
                leaguesRepo.fetchSeasons(endPoint: LeaguesEndPoints.getSeasons(code: code)) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let model):
                                continuation.resume(returning: model)
                            case .failure(let failure):
                                let message = failure.description
                                let error = CustomDomainError.error(message)
                                continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }catch{
            print(error)
            return nil
        }
    }
    private func fetchTeams(code:String) async -> TeamsDataModel?{
        do{
            return try await withCheckedThrowingContinuation { continuation in
                leaguesRepo.fetchTeams(endPoint: LeaguesEndPoints.getTeams(code: code)) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let model):
                                continuation.resume(returning: model)
                            case .failure(let failure):
                                let message = failure.description
                                let error = CustomDomainError.error(message)
                                continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }catch{
            print(error)
            return nil
        }
    }
    private func fetchMatches(code:String) async -> MatchesDataModel?{
        do{
            return try await withCheckedThrowingContinuation(){ continuation in
                leaguesRepo.fetchMatches(endPoint: LeaguesEndPoints.getMatches(code: code)) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let model):
                                continuation.resume(returning: model)
                            case .failure(let failure):
                                let message = failure.description
                                let error = CustomDomainError.error(message)
                                continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }catch{
            print(error)
            return nil
        }
    }
    
}




//
//private func handle(data: [Competition],completions:LeaguesCompletions){
//    data.forEach { competition in
//        guard let code = competition.code else {return}
//        concurrentQueue.async {
//            //                group.enter()
//            //                enter += 1
//            leaguesRepo.fetchSeasons(endPoint: LeaguesEndPoints.getSeasons(code: code)) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                        case .success(let model):
//                            completions.seasonsCompletion(.success(model))
//                        case .failure(let failure):
//                            let message = failure.description
//                            let error = CustomDomainError.error(message)
//                            completions.seasonsCompletion(.failure(error))
//                    }
//                    //                        group.leave()
//                    //                        enter -= 1
//                }
//            }
//
//            //                group.enter()
//            //                enter += 1
//            leaguesRepo.fetchTeams(endPoint: LeaguesEndPoints.getTeams(code: code)) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                        case .success(let model):
//                            completions.teamsCompletion(.success(model))
//                        case .failure(let failure):
//                            let message = failure.description
//                            let error = CustomDomainError.error(message)
//                            completions.seasonsCompletion(.failure(error))
//                    }
//                    //                        group.leave()
//                    //                        enter -= 1
//                }
//            }
//
//            //                enter += 1
//            //                group.enter()
//            leaguesRepo.fetchMatches(endPoint: LeaguesEndPoints.getMatches(code: code)) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                        case .success(let model):
//                            completions.matchesCompletion(.success(model))
//                        case .failure(let failure):
//                            let message = failure.description
//                            let error = CustomDomainError.error(message)
//                            completions.seasonsCompletion(.failure(error))
//                    }
//                    //                        group.leave()
//                    //                        enter -= 1
//                }
//            }
//        }
//    }
//    //        group.notify(queue: .main){
//    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//    //                completions.completion()
//    //            }
//    //        }
//    }
