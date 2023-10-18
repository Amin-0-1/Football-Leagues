//
//  LeaguesViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import Foundation
import RxSwift
import RxCocoa


// MARK: - View model output protocol
protocol LeaguesViewModelOutputProtocol{
    var progress: Driver<Bool> {get}
    var showError: Driver<String> {get}
    var onFinishFetchingLeagues: Driver<[LeaguesVieweDataModel]> {get}
}

struct LeaguesVMOutput:LeaguesViewModelOutputProtocol{
    var progress: Driver<Bool>
    var showError: Driver<String>
    var onFinishFetchingLeagues: Driver<[LeaguesVieweDataModel]>
     
    fileprivate var progressSubject: PublishSubject<Bool>
    fileprivate var showErrorSubject: PublishSubject<String>
    fileprivate var onFinishFetchingLeaguesSubject: PublishSubject<[LeaguesVieweDataModel]>
    
    init(){
        
        progressSubject = PublishSubject()
        showErrorSubject = PublishSubject()
        onFinishFetchingLeaguesSubject = PublishSubject()
     
        progress = progressSubject.asDriver(onErrorJustReturn: false)
        showError = showErrorSubject.asDriver(onErrorJustReturn: "")
        onFinishFetchingLeagues = onFinishFetchingLeaguesSubject.asDriver(onErrorJustReturn: [])
    }
    
}


protocol LeaguesVMProtocol{
    var input:LeaguesVMInput! {get}
    var outPut:LeaguesVMOutput! {get}
}




// MARK: - View-model
class LeaguesViewModel:LeaguesVMProtocol{
    var input: LeaguesVMInput!
    var outPut: LeaguesVMOutput!
    
    var usecase:LeaguesUsecaseProtocol
    var leagues:[LeaguesVieweDataModel] = []
    
    private var bag:DisposeBag!
    
    init(usecase:LeaguesUsecaseProtocol) {
        self.input = LeaguesVMInput()
        self.outPut = LeaguesVMOutput()
        self.usecase = usecase
        bag = DisposeBag()
        bind()
    }
    
    private func bind(){
        
        input.onScreenAppeared.bind { [weak self] isPullToRefresh in
            guard let self = self else {return}
            
            isPullToRefresh ? nil : self.outPut.progressSubject.onNext(true)
            
            
            usecase.fetch(completions: .init(
                leaguesCompletion: { result in
                isPullToRefresh ? nil : self.outPut.progressSubject.onNext(false)
                switch result{
                    case .success(let leagues):
                        let models = self.handle(data: leagues.competitions)
                        self.leagues = models
                        self.outPut.onFinishFetchingLeaguesSubject.onNext(models)
                    case .failure(let error):
                        self.outPut.showErrorSubject.onNext(error.description)
                        debugPrint(error)

                }
            }, seasonsCompletion: { result in
                switch result{
                    case .success(let model):
                        if let index = self.leagues.firstIndex(where: {$0.code == model.code}){
                            let position = self.leagues.distance(from: 0, to: index)
                            self.leagues[position].numberOfSeasons = model.seasons?.count
                        }
                    case .failure(let error):
                        debugPrint(error.description)
                }
            }, teamsCompletion: { result in
                switch result{
                    case .success(let model):
                        if let index = self.leagues.firstIndex(where: {$0.code == model.competition?.code}){
                            let position = self.leagues.distance(from: 0, to: index)
                            self.leagues[position].numberOfTeams = model.teams?.count
                        }
                    case .failure(let error):
                        debugPrint(error.description)
                }
            }, matchesCompletion: { result in
                switch result{
                    case .success(let model):
                        if let index = self.leagues.firstIndex(where: {$0.code == model.competition?.code}){
                            let position = self.leagues.distance(from: 0, to: index)
                            self.leagues[position].numberOfMatches = model.matches?.count
                        }
                    case .failure(let error):
                        debugPrint(error.description)
                }
            },completion: {
                self.outPut.onFinishFetchingLeaguesSubject.onNext(self.leagues)
            }))
        }.disposed(by: bag)
    }
    
    private func handle(data:[Competition]) -> [LeaguesVieweDataModel]{
        var models: [LeaguesVieweDataModel] = []

        data.forEach { competition in
            let obj = LeaguesVieweDataModel(imageUrl: competition.emblem,title: competition.name, code: competition.code)
            models.append(obj)
        }
        return models
    }
}
