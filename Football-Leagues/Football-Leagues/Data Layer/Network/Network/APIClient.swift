//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint) -> Future<T, NetworkError>
}

class APIClient:NSObject, URLSessionDataDelegate,APIClientProtocol{
    
    static let shared = APIClient(config: .default)
    private var session: URLSession!
    
    private init(config: URLSessionConfiguration) {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func execute<T:Codable>(request:EndPoint) -> Future<T, NetworkError>{
        
        return Future<T,NetworkError>{ promise in
            let task = self.session.dataTask(with: request.request){ data, response, error in
                
                if let error = error {
                    if let urlError = error as? URLError {
                        switch urlError.code {
                            case .notConnectedToInternet:
                                promise(.failure(.noInternetConnection))
                            case .timedOut:
                                promise(.failure(.timeout))
                            default:
                                promise(.failure(.requestFailed))
                                
                        }
                    } else {
                        promise(.failure(.requestFailed))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    if let httpResponse = response as? HTTPURLResponse {
                        promise(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    } else {
                        promise(.failure(.invalidResponse))
                    }
                    return
                }
                
                guard let data = data else {
                    promise(.failure(.invalidResponse))
                    return
                }
                
                guard let model = try? JSONDecoder().decode(T.self, from: data)else {
                    promise(.failure(.decodingFailed))
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    promise(.success(model))
                }
            }
            task.resume()
        }
    }
}


