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
    var Leagues:LeagueDataModel?
    private var bag:DisposeBag!
    
    init(usecase:LeaguesUsecaseProtocol) {
        self.input = LeaguesVMInput()
        self.outPut = LeaguesVMOutput()
        self.usecase = usecase
        bag = DisposeBag()
        bind()
    }
    
    private func bind(){
        input.onScreenAppeared.bind { [weak self] _ in
            guard let self = self else {return}
            self.outPut.progressSubject.onNext(true)
            usecase.fetch { result in
                self.outPut.progressSubject.onNext(false)
                switch result{
                    case .success(let model):
                        let models = self.handle(data: model.competitions)
                        self.outPut.onFinishFetchingLeaguesSubject.onNext(models)
                        self.Leagues = model
                    case .failure(let error):
                        self.outPut.showErrorSubject.onNext(error.localizedDescription)
                        print(error)
                }
            }
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
