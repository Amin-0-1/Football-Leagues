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
struct LeaguesViewModel:LeaguesVMProtocol{
    var input: LeaguesVMInput!
    var outPut: LeaguesVMOutput!
    
    var usecase:LeaguesUsecaseProtocol
    var leagues:[LeaguesVieweDataModel] = []
    
    private var bag:DisposeBag!
    
    init(usecase:LeaguesUsecaseProtocol = LeaguesUsecase()) {
        self.input = LeaguesVMInput()
        self.outPut = LeaguesVMOutput()
        self.usecase = usecase
        bag = DisposeBag()
        bind()
    }
    
    private func bind(){
        
        input.onScreenAppeared.bind { isPullToRefresh in
            isPullToRefresh ? nil : self.outPut.progressSubject.onNext(true)
            
            usecase.fetchLeagues().subscribe(onSuccess: { result in
                outPut.progressSubject.onNext(false)
                switch result{
                    case .success(let model):
                        let newModel = model.competitions.compactMap{
                            LeaguesVieweDataModel(imageUrl: $0.emblem, name: $0.name, code: $0.code, numberOfSeasons: $0.numberOfAvailableSeasons, area: $0.area?.code, type: $0.type)
                        }
                        outPut.onFinishFetchingLeaguesSubject.onNext(newModel)
                    case .failure(let error):
                        outPut.showErrorSubject.onNext(error.localizedDescription)
                }
            }).disposed(by: bag)
            
        }.disposed(by: bag)
    }
}

