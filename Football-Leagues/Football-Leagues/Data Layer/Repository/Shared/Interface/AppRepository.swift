//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

protocol AppRepositoryInterface{
    func fetch<T:Codable>(endPoint: EndPoint,localFetchType:LocalFetchType,type: T.Type) -> Single<Result<T, Error>>
    func save<T:Codable>(data: T)
}

// MARK: - single interface for a complex subsystems
struct AppRepository:AppRepositoryInterface{

   
    private var local:LocalRepositoryInterface!
    private var remote:RemoteRepositoryInterface!
    private var bag:DisposeBag!
    init(local: LocalRepositoryInterface = LocalRepository(), remote: RemoteRepositoryInterface = RemoteRepository()) {
        self.local = local
        self.remote = remote
        bag = DisposeBag()
    }
    
    func fetch<T:Codable>(endPoint: EndPoint,localFetchType:LocalFetchType,type: T.Type) -> Single<Result<T, Error>> {
        return Single.create { single in
            local.fetch(model: localFetchType, type: type).subscribe(onSuccess: { event in
                switch event{
                    case .success(let model):
                        single(.success(.success(model)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                        debugPrint(error.localizedDescription)
                }
                
                remote.fetch(endPoint: endPoint, type: type).subscribe(onSuccess: { event in
                    switch event{
                        case .success(let model):
                            single(.success(.success(model)))
                            save(data: model)
                        case .failure(let error):
                            single(.success(.failure(error)))
                            debugPrint(error)
                    }
                }).disposed(by: bag)
                
            }).disposed(by: bag)

            return Disposables.create()
        }
        
    }
    
    func save<T:Codable>(data: T) {
        local.save(data: data)
    }
    
}

