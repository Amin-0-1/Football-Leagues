//
//  CoreDataManager.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import Foundation
import CoreData
import Combine


protocol CoreDataManagerProtocol{
    func insert<T:Codable>(data:T,localEndPoint:LocalEndPoint)->Future<Bool,Error>
    func fetch<T:Codable>(localEndPoint:LocalEndPoint)-> Future<T,Error>
}


extension CoreDataManager:CoreDataManagerProtocol{
    
    func insert<T:Codable>(data: T, localEndPoint: LocalEndPoint)-> Future<Bool,Error> {
        
        return Future<Bool, Error> { promise in
            self.performBackgroundTask { context in
                self.truncate(entity: localEndPoint, context: context)
                switch localEndPoint {
                    case .leagues:
                        let obj = LeagueEntity(context: context)
                        if let type = data as? LeaguesDataModel{
                            guard let encoded = try? JSONEncoder().encode(type) else {
                                promise(.failure(Errors.decodingFailed))
                                return
                            }
                            obj.data = encoded
                        }
                    case .teams(let code):
                        let obj = LeagueDetailsEntity(context: context)
                        if let type = data as? LeagueDetailsDataModel{
                            guard let encoded = try? JSONEncoder().encode(type) else {
                                promise(.failure(Errors.decodingFailed))
                                return
                            }
                            obj.data = encoded
                            obj.code = code
                        }
                    case .games(let id):
                        let obj = GamesEntity(context: context)
                        if let type = data as? TeamDataModel{
                            guard let encoded = try? JSONEncoder().encode(type) else {
                                promise(.failure(Errors.decodingFailed))
                                return
                            }
                            obj.data = encoded
                            obj.id = Int16(id)
                        }
                        break
                }
                do {
                    try context.save()
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                    debugPrint(error)
                }
            }
        }
    }
    
    private func generateRequest(from localEntity:LocalEndPoint) -> NSFetchRequest<NSFetchRequestResult>{
        let request: NSFetchRequest<NSFetchRequestResult>!
        switch localEntity {
            case .leagues: 
                request = LeagueEntity.fetchRequest()
            case .teams(let code):
                request = LeagueDetailsEntity.fetchRequest()
                let attribute = "code"
                let predicate = NSPredicate(format: "%K == %@",attribute,code)
                request.predicate = predicate
                
            case .games(let id):
                request = GamesEntity.fetchRequest()
                let attribute = "id"
                let predicate = NSPredicate(format: "%K == %ld",attribute,id)
                request.predicate = predicate
                
        }
        return request
    }

    func fetch<T:Codable>(localEndPoint:LocalEndPoint)-> Future<T,Error>{
        let request = generateRequest(from: localEndPoint)
        var allData: [NSFetchRequestResult] = []
        
        return Future<T, Error>{ promise in
            do{
                
                allData = try self.mainContext.fetch(request)
                guard let first = allData.first else{
                    promise(.failure(Errors.empty))
                    return
                }
                
                switch localEndPoint {
                    case .leagues:
                        guard let leagueEntity = first as? LeagueEntity else{
                            promise(.failure(Errors.uncompleted))
                            return
                        }
                        guard let data = leagueEntity.data else {promise(.failure(Errors.decodingFailed));return}
                        guard let decode = try? JSONDecoder().decode(T.self, from: data) else{
                            promise(.failure(Errors.decodingFailed))
                            return
                        }
                        promise(.success(decode))
                    case .teams:
                        guard let detailsEntity = first as? LeagueDetailsEntity else{
                            promise(.failure(Errors.uncompleted))
                            return
                        }
                        guard let data = detailsEntity.data else {promise(.failure(Errors.decodingFailed));return}
                        guard let decode = try? JSONDecoder().decode(T.self, from: data) else{
                            promise(.failure(Errors.decodingFailed))
                            return
                        }
                        promise(.success(decode))
                    case .games:
                        guard let gamesEntity = first as? GamesEntity else{
                            promise(.failure(Errors.uncompleted))
                            return
                        }
                        guard let data = gamesEntity.data else {promise(.failure(Errors.decodingFailed));return}
                        guard let decode = try? JSONDecoder().decode(T.self, from: data) else{
                            promise(.failure(Errors.decodingFailed))
                            return
                        }
                        promise(.success(decode))
                }
                
            }catch{
                promise(.failure(error))
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func truncate(entity:LocalEndPoint,context:NSManagedObjectContext){
        var request: NSFetchRequest<NSFetchRequestResult>
        switch entity {
            case .leagues:
                request = LeagueEntity.fetchRequest()
            case .teams(let code):
                request = LeagueDetailsEntity.fetchRequest()
                let attribute = "code"
                let predicate = NSPredicate(format: "%K == %@",attribute,code)
                request.predicate = predicate
            case .games(let id):
                request = GamesEntity.fetchRequest()
                let attribute = "id"
                let predicate = NSPredicate(format: "%K == %ld",attribute,id)
                request.predicate = predicate
        }
        do{
            let allRecord = try context.fetch(request)
            allRecord.forEach { record in
                context.delete(record as! NSManagedObject)
            }
            try context.save()
        }catch{
            debugPrint(error)
        }
    }
}


extension CoreDataManager{

    enum Errors: Error{
        case empty
        case uncompleted
        case decodingFailed
        case custom(String)
        var localizedDescription:String{
            switch self{
                case .empty:
                    return "Data not found locally, so please reconnect to the internet"
                case .uncompleted:
                    return "Uncompleted process, please try again later"
                case .decodingFailed:
                    return "Failed to decode data locally"
                case .custom(let string):
                    return string
            }
        }
    }
}

