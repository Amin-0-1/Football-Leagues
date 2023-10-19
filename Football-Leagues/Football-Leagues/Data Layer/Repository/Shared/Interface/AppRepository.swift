//
//  AppRepository.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

// MARK: - single interface for a complex subsystems

protocol AppRepositoryInterface{
    func fetch<T:Codable>(endPoint:EndPoint,type:T.Type) -> Single<Result<T,Error>>
    func save(competitions:[Competition])
}
struct AppRepository:AppRepositoryInterface{
    
    private var local:LocalRepositoryInterface!
    private var remote:RemoteRepositoryInterface!
    private var bag:DisposeBag!
    init(local: LocalRepositoryInterface = LocalRepository(), remote: RemoteRepositoryInterface = RemoteRepository()) {
        self.local = local
        self.remote = remote
        bag = DisposeBag()
    }
    
    func fetch<T>(endPoint: EndPoint, type: T.Type) -> Single<Result<T, Error>> where T : Decodable, T : Encodable {
        return Single.create { single in
            isConnected { connected in
                if connected{
                    remote.fetch(endPoint: endPoint, type: type).subscribe(onSuccess: { event in
                        single(.success(event))
                    }).disposed(by: bag)
                }else{
//                    local.fetch(endPoint:endPoint,type: type).subscribe(onSuccess: { event in
//                        single(.success(event))
//                    }).disposed(by: bag)
                }
            }
            return Disposables.create()
        }
        
    }
    
    func save(competitions:[Competition]){
        local.save(data: competitions)
    }
}

