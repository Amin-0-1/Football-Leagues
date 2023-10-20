//
//  Connectivity.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

func Connection(completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "https://www.google.com") else {
        completion(false)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (_, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(false)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           (200...299).contains(httpResponse.statusCode) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    task.resume()
}

