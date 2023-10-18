//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint) -> Single<Result<T, Error>>
}

class APIClient:NSObject, URLSessionDataDelegate,APIClientProtocol{
    
    private var session: URLSession!
    
    init(config: URLSessionConfiguration) {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    convenience override init() {
        self.init(config: .default)
        
    }
    func execute<T:Codable>(request:EndPoint) -> Single<Result<T, Error>> {
        
        return Single.create { single in
            let task = self.session.dataTask(with: request.request){ data, response, error in
                
                if let error = error{
                    single(.success(.failure(error)))
                    return
                }
                if let response = response as? HTTPURLResponse,
                   response.statusCode >= 200, response.statusCode < 300,
                   let data = data  {
                    guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                        single(.success(.failure(NetworkError.jsonParsingFailure(data: data))))
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        single(.success(.success(model)))
                    }
                } else {
                    guard let data = data else {
                        single(.success(.failure(NetworkError.invalidData)))
                        return
                    }
                    single(.success(.failure(NetworkError.requestFailed(data: data))))
                }
                
            }
            task.resume()
            return Disposables.create {task.cancel()}
        }
    }
}


