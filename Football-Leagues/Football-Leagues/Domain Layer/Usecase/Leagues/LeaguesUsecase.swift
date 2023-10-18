//
//  LeaguesUsecase.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

var enter = 0
protocol LeaguesUsecaseProtocol{
    func fetch(completions:LeaguesCompletions)
}

struct LeaguesUsecase : LeaguesUsecaseProtocol{
    
    private var leaguesRepo:LeaguesRepoInterface!
    private let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", qos: .background, attributes: .concurrent)
    private var group:DispatchGroup!
    init(leaguesRepo: LeaguesRepoInterface) {
        self.leaguesRepo = leaguesRepo
        group = DispatchGroup()
    }
    func fetch(completions: LeaguesCompletions) {
        leaguesRepo.fetchLeagues(endPoint: LeaguesEndPoints.getAllLeagues) { result in
            switch result {
                case .success(let model):
                    self.handle(data: model.competitions,completions:completions)
                    completions.leaguesCompletion(.success(model))
                case .failure(let failure):
                    let message = failure.description
                    let error = CustomDomainError.error(message)
                    completions.leaguesCompletion(.failure(error))
            }
        }
        
    }
    private func handle(data: [Competition],completions:LeaguesCompletions){
        data.forEach { competition in
            guard let code = competition.code else {return}
            concurrentQueue.async {
                group.enter()
                enter += 1
                leaguesRepo.fetchSeasons(endPoint: LeaguesEndPoints.getSeasons(code: code)) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let model):
                                completions.seasonsCompletion(.success(model))
                            case .failure(let failure):
                                let message = failure.description
                                let error = CustomDomainError.error(message)
                                completions.seasonsCompletion(.failure(error))
                        }
                        group.leave()
                        enter -= 1
                    }
                }
                
                group.enter()
                enter += 1
                leaguesRepo.fetchTeams(endPoint: LeaguesEndPoints.getTeams(code: code)) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let model):
                                completions.teamsCompletion(.success(model))
                            case .failure(let failure):
                                let message = failure.description
                                let error = CustomDomainError.error(message)
                                completions.seasonsCompletion(.failure(error))
                        }
                        group.leave()
                        enter -= 1
                    }
                }  
                
                enter += 1
                group.enter()
                leaguesRepo.fetchMatches(endPoint: LeaguesEndPoints.getMatches(code: code)) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let model):
                                completions.matchesCompletion(.success(model))
                            case .failure(let failure):
                                let message = failure.description
                                let error = CustomDomainError.error(message)
                                completions.seasonsCompletion(.failure(error))
                        }
                        group.leave()
                        enter -= 1
                    }
                }
            }
        }
        group.notify(queue: .main){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                completions.completion()
            }
        }
    }
}
