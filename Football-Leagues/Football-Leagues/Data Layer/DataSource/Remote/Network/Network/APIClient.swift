//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func execute<T: Codable>(request: EndPoint) -> AnyPublisher<T, Error>
}

class APIClient: APIClientProtocol {
    static let shared = APIClient(config: .default)
    private var session: URLSession
    
    init(config: URLSessionConfiguration) {
        self.session = URLSession(configuration: config)
    }
    
    func execute<T: Codable>(request: EndPoint) -> AnyPublisher<T, Error> {
        guard let request = request.request else {
            let url = request.urlComponents.string
            return Fail(error: NetworkError.invalidURL(url)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode) else {
                    self.serialize(data: data)
                    throw NetworkError.serverError(data)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError {
                    switch urlError.code {
                        case .notConnectedToInternet:
                            return NetworkError.noInternetConnection
                        case .timedOut:
                            return NetworkError.timeout
                        case .badURL:
                            return NetworkError.invalidURL(nil)
                        default:
                            return NetworkError.requestFailed
                    }
                } else if let decodingError = error as? DecodingError {
                    print(decodingError.localizedDescription, decodingError)
                    return NetworkError.decodingFailed
                } else {
                    print(error.localizedDescription, error)
                    return NetworkError.custom(
                        error: error.localizedDescription,
                        code: (error as NSError).code
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Serialize
    /// - Parameter data: the data object to be serialized
    private func serialize(data: Data) {
        do {
            let object = try JSONSerialization.jsonObject(with: data)
            print(object)
        } catch {
            print(error.localizedDescription, error)
        }
    }
}
