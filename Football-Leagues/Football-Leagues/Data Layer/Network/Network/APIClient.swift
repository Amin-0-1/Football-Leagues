//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
var count = 0
protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint, completion:@escaping (Swift.Result<T,NetworkError>)->Void)
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
    
    func execute<T:Codable>(request:EndPoint, completion:@escaping (Swift.Result<T,NetworkError>)->Void) {
        let task = session.dataTask(with: request.request) { data, response, error in
            count += 1
            print(count,T.self)
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
                guard let serialized = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    completion(.failure(NetworkError.requestFailed(data: data)))
                    return
                }
                guard let message = serialized["message"] as? String else {return}
                completion(.failure(NetworkError.serialized(message: message)))
            }
            
        }
        task.resume()
    }
}
