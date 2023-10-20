//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import RxSwift

protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint,type:T.Type) -> Single<Result<T, NetworkError>>
}

class APIClient:NSObject, URLSessionDataDelegate,APIClientProtocol{
    
    static let shared = APIClient(config: .default)
    private var session: URLSession!
    
    private init(config: URLSessionConfiguration) {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func execute<T:Codable>(request:EndPoint,type:T.Type) -> Single<Result<T, NetworkError>> {
        
        return Single.create { single in
            let task = self.session.dataTask(with: request.request){ data, response, error in
                
                if let error = error {
                    if let urlError = error as? URLError {
                        switch urlError.code {
                            case .notConnectedToInternet:
                                single(.success(.failure(.noInternetConnection)))
                            case .timedOut:
                                single(.success(.failure(.timeout)))
                            default:
                                single(.success(.failure(.requestFailed)))

                        }
                    } else {
                        single(.success(.failure(.requestFailed)))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    if let httpResponse = response as? HTTPURLResponse {
                        single(.success(.failure(.serverError(statusCode: httpResponse.statusCode))))
                    } else {
                        single(.success(.failure(.invalidResponse)))
                    }
                    return
                }
                
                guard let data = data else {
                    single(.success(.failure(.invalidResponse)))
                    return
                }
                
                guard let model = try? JSONDecoder().decode(T.self, from: data)else {
                    single(.success(.failure(.decodingFailed)))
                    return
                }
                
                single(.success(.success(model)))
            }
            task.resume()
            return Disposables.create {task.cancel()}
        }
    }
}


