//
//  CoreDataManager.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import Foundation
import CoreData
import Combine

protocol CoreDataManagerProtocol {
    func insert<T: Codable>(data: T, localEndPoint: LocalEndPoint) -> Future<T, Error>
    func fetch<T: Codable>(localEndPoint: LocalEndPoint) -> Future<T, Error>
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    func insert<T: Codable>(data: T, localEndPoint: LocalEndPoint) -> Future<T, Error> {
        
        return Future<T, Error> { promise in
            self.performBackgroundTask { context in
                var encodedData: Data?
                self.truncate(entity: localEndPoint, context: context)
                switch localEndPoint {
                    case .leagues:
                        let obj = LeagueEntity(context: context)
                        encodedData = try? JSONEncoder().encode(data)
                        guard let encoded = encodedData  else {
                            promise(.failure(Errors.encodingFailed))
                            return
                        }
                        obj.data = encoded
                    case .teams(let code):
                        let obj = LeagueDetailsEntity(context: context)
                        encodedData = try? JSONEncoder().encode(data)
                        guard let encoded = encodedData  else {
                            promise(.failure(Errors.encodingFailed))
                            return
                        }
                        obj.data = encoded
                        obj.code = code
                    case .games(let id):
                        let obj = GamesEntity(context: context)
                        encodedData = try? JSONEncoder().encode(data)
                        guard let encoded = encodedData  else {
                            promise(.failure(Errors.encodingFailed))
                            return
                        }
                        obj.data = encoded
                        obj.id = Int16(id)
                    case .staff(let id):
                        let obj = StaffEntity(context: context)
                        encodedData = try? JSONEncoder().encode(data)
                        guard let encodedData = encodedData else {
                            promise(.failure(Errors.encodingFailed))
                            return
                        }
                        obj.data = encodedData
                        obj.id = Int16(id)
                }
                do {
                    try context.save()
                    promise(.success(data))
                } catch {
                    promise(.failure(error))
                    debugPrint(error)
                }
            }
        }
    }
    
    private func generateRequest(from localEntity: LocalEndPoint) -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult>
        let attribute: String
        let predicate: NSPredicate
        switch localEntity {
            case .leagues:
                request = LeagueEntity.fetchRequest()
            case .teams(let code):
                request = LeagueDetailsEntity.fetchRequest()
                attribute = "code"
                predicate = NSPredicate(format: "%K == %@", attribute, code)
                request.predicate = predicate
                
            case .games(let id):
                request = GamesEntity.fetchRequest()
                attribute = "id"
                predicate = NSPredicate(format: "%K == %ld", attribute, id)
                request.predicate = predicate
            case .staff(let id):
                request = StaffEntity.fetchRequest()
                attribute = "id"
                predicate = NSPredicate(format: "%K == %ld", attribute, id)
                request.predicate = predicate
                
        }
        return request
    }
    
    private func decode<T: Codable>(result: NSFetchRequestResult, withType type: T.Type, withEndPoint localEndPoint: LocalEndPoint) throws -> T {
        switch localEndPoint {
            case .leagues:
                guard let leagueEntity = result as? LeagueEntity else {
                    throw Errors.uncompleted
                }
                guard let data = leagueEntity.data else {
                    throw Errors.decodingFailed
                }
                guard let decode = try? JSONDecoder().decode(type, from: data) else {
                    throw Errors.decodingFailed
                }
                return decode
            case .teams:
                guard let detailsEntity = result as? LeagueDetailsEntity else {
                    throw Errors.uncompleted
                }
                guard let data = detailsEntity.data else {
                    throw Errors.decodingFailed
                }
                guard let decode = try? JSONDecoder().decode(type, from: data) else {
                    throw Errors.decodingFailed
                }
                return decode
            case .games:
                guard let gamesEntity = result as? GamesEntity else {
                    throw Errors.uncompleted
                }
                guard let data = gamesEntity.data else {
                    throw Errors.decodingFailed
                }
                guard let decode = try? JSONDecoder().decode(type, from: data) else {
                    throw Errors.decodingFailed
                }
                return decode
            case .staff:
                guard let staffEntity = result as? StaffEntity else {
                    throw Errors.uncompleted
                }
                guard let data = staffEntity.data else {
                    throw Errors.decodingFailed
                }
                guard let decode = try? JSONDecoder().decode(type, from: data) else {
                    throw Errors.decodingFailed
                }
                return decode
        }
    }

    func fetch<T: Codable>(localEndPoint: LocalEndPoint) -> Future<T, Error> {
        let request = generateRequest(from: localEndPoint)
        var allData: [NSFetchRequestResult] = []
        
        return Future<T, Error> { promise in
            do {
                
                allData = try self.mainContext.fetch(request)
                guard let result = allData.first else {
                    promise(.failure(Errors.empty))
                    return
                }
                let decoded = try? self.decode(result: result, withType: T.self, withEndPoint: localEndPoint)
                guard let decoded = decoded else {
                    promise(.failure(Errors.decodingFailed))
                    return
                }
                
                promise(.success(decoded))
            } catch {
                promise(.failure(error))
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func truncate(entity: LocalEndPoint, context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult>
        let attribute: String
        let predicate: NSPredicate
        switch entity {
            case .leagues:
                request = LeagueEntity.fetchRequest()
            case .teams(let code):
                request = LeagueDetailsEntity.fetchRequest()
                attribute = "code"
                predicate = NSPredicate(format: "%K == %@", attribute, code)
                request.predicate = predicate
            case .games(let id):
                request = GamesEntity.fetchRequest()
                attribute = "id"
                predicate = NSPredicate(format: "%K == %ld", attribute, id)
                request.predicate = predicate
            case .staff(let id):
                request = StaffEntity.fetchRequest()
                attribute = "id"
                predicate = NSPredicate(format: "%K == %ld", attribute, id)
                request.predicate = predicate
        }
        do {
            let allRecord = try context.fetch(request)
            allRecord.forEach { record in
                if let record = record as? NSManagedObject {
                    context.delete(record)
                }
            }
            try context.save()
        } catch {
            debugPrint(error)
        }
    }
}

extension CoreDataManager {

    enum Errors: Error {
        case empty
        case uncompleted
        case decodingFailed
        case encodingFailed
        case custom(String)
        var localizedDescription: String {
            switch self {
                case .empty:
                    return "no local data found"
                case .uncompleted:
                    return "Uncompleted process, please try again later"
                case .decodingFailed:
                    return "Failed to decode local data"
                case .encodingFailed:
                    return "Failed to encode local data"
                case .custom(let string):
                    return string
            }
        }
    }
}
