//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint, completion:@escaping (Swift.Result<T,Error>)->Void)
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
    
    func execute<T: Codable>(request: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request.request) { data, response, error in
            
            if let response = response as? HTTPURLResponse,
               response.statusCode >= 200, response.statusCode < 300,
               let data = data  {
                guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(Result.failure(NetworkError.jsonParsingFailure(data: data)))
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    completion(.success(model))
                }
            } else {
                guard let data = data else {
                    completion(.failure(NetworkError.invalidData))
                    return
                }
                completion(.failure(NetworkError.requestFailed(data: data)))
            }
            
        }
        task.resume()
    }
}
