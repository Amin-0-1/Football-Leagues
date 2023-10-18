//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint,type:T) -> Observable<Result<T, Error>>
}

class APIClient:NSObject, URLSessionDataDelegate, URLSessionTaskDelegate,APIClientProtocol{
    
    private var session: URLSession!
    
    init(config: URLSessionConfiguration) {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    convenience override init() {
        self.init(config: .default)
    }
    func execute<T:Codable>(request: EndPoint, type: T) -> Observable<Result<T, Error>> {
        return Observable.create { observer in
            let task = self.session.dataTask(with: request.request) { data, response, error in
                
                if let error = error{
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode >= 200, response.statusCode < 300,
                   let data = data  {
                    guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                        observer.onNext(.failure(NetworkError.jsonParsingFailure(data: data)))
                        observer.onCompleted()
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        observer.onNext(.success(model))
                        observer.onCompleted()
                    }
                } else {
                    guard let data = data else {
                        observer.onNext(.failure(NetworkError.invalidData))
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(.failure(NetworkError.requestFailed(data: data)))
                }
                
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
