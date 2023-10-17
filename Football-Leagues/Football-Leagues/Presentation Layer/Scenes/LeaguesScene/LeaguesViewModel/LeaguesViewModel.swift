//
//  LeaguesViewModel.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class LeaguesViewModel:LeaguesVMProtocol{
    var input: LeaguesVMInput!
    var outPut: LeaguesVMOutput!
    
    var usecase:LeaguesUsecaseProtocol
    
    private var bag:DisposeBag!
    
    init(usecase:LeaguesUsecaseProtocol) {
        self.input = LeaguesVMInput()
        self.outPut = LeaguesVMOutput()
        self.usecase = usecase
        bind()
    }
    
    private func bind(){
        input.onScreenAppeared.bind { [weak self] _ in
            guard let self = self else {return}
        }.disposed(by: bag)
    }
}
