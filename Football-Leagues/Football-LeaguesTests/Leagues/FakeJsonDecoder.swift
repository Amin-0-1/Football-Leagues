//
//  FakeJsonDecode.swift
//  Football-LeaguesTests
//
//  Created by Amin on 20/10/2023.
//

import Foundation

class FakeJsonDecoder{
    func getModelFrom<T:Decodable>(jsonFile name:String,fileType:String = "json",decodeType:T.Type)->T?{
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: fileType)
        else {return nil}
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(decodeType, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
        
    
}
