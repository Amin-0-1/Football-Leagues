//
//  Connectivity.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

protocol ConnectivityProtocol{
    func isConnected(completion: @escaping (Bool) -> Void)
}

class ConnectivityService:ConnectivityProtocol{
    func isConnected(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.google.com") else {
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (_, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
        
        task.resume()

    }
}

