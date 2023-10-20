//
//  RemoteDataSource.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

struct RemoteRepository:RemoteRepositoryInterface{
    
    
    private var apiClinet:APIClientProtocol!
    private var bag:DisposeBag!
    init(apiClinet: APIClientProtocol = APIClient.shared) {
        self.apiClinet = apiClinet
        bag = DisposeBag()
    }
    
    func fetch<T>(endPoint: EndPoint, type: T.Type) -> Single<Result<T, Error>>  where T: Decodable, T: Encodable{

        return Single.create { single in
            apiClinet.execute(request: endPoint, type: type).subscribe(onSuccess: { event in
                switch event{
                    case .success(let model):
                        single(.success(.success(model)))
                    case .failure(let error):
                        let error = NSError(domain: error.localizedDescription, code: 0)
                        single(.success(.failure(error)))
                }
            }).disposed(by: bag)

            return Disposables.create()
        }
    }
}
