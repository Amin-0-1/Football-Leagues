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
    func insert<T:Codable>(data:T,localEntityType:LocalEntityType)->Future<Bool,Error>
    func fetch<T:Codable>(localEntityType:LocalEntityType)-> Future<T,Error>
}
class CoreDataManager:CoreDataManagerProtocol{
    
    private let coreData = CoreDataStack.getInstance(withModel: AppConfiguration.shared.dataModel)
    
    public static let shared = CoreDataManager()
    private init(){}
    
    
    func insert<T:Codable>(data: T, localEntityType: LocalEntityType)-> Future<Bool,Error> {
    
        return Future<Bool, Error> { promise in

            self.coreData.performBackgroundTask { context in
                self.truncate(entity: localEntityType, context: context)
                switch localEntityType {
                    case .leagues:
                        let obj = LeagueEntity(context: context)
                        if let type = data as? LeagueDataModel{
                            guard let encoded = try? JSONEncoder().encode(type) else {
                                promise(.failure(Errors.decodingFailed))
                                return
                            }
                            obj.data = encoded
                        }
                    case .teams(let code):
                        let obj = LeagueDetailsEntity(context: context)
                        if let type = data as? TeamsDataModel{
                            guard let encoded = try? JSONEncoder().encode(type) else {
                                promise(.failure(Errors.decodingFailed))
                                return
                            }
                            obj.data = encoded
                            obj.code = code
                        }
                    case .games(let id):
                        let obj = GamesEntity(context: context)
                        if let type = data as? GamesDataModel{
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
    
    private func generateRequest(from localEntity:LocalEntityType) -> NSFetchRequest<NSFetchRequestResult>{
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

    func fetch<T:Codable>(localEntityType:LocalEntityType)-> Future<T,Error>{
        let request = generateRequest(from: localEntityType)
        var allData: [NSFetchRequestResult] = []
        return Future<T, Error>{ promise in
            do{
                allData = try self.coreData.mainContext.fetch(request)
                guard let first = allData.first else{
                    promise(.failure(Errors.empty))
                    return
                }
                
                switch localEntityType {
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
    
    private func truncate(entity:LocalEntityType,context:NSManagedObjectContext){
        var request: NSFetchRequest<NSFetchRequestResult>
        switch entity {
            case .leagues:
                request = LeagueEntity.fetchRequest()
            case .teams(let code):
                request = LeagueEntity.fetchRequest()
                let fetch: NSFetchRequest<LeagueDetailsEntity> = LeagueDetailsEntity.fetchRequest()
                let attribute = "code"
                let predicate = NSPredicate(format: "%K == %@",attribute,code)
                fetch.predicate = predicate
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
                    return "data not found locally, so please reconnect to the internet"
                case .uncompleted:
                    return "uncompleted process"
                case .decodingFailed:
                    return "failed to decode data locally"
                case .custom(let string):
                    return string
            }
        }
    }
}






//            switch localEntityType {
//                case .leagues:
//                    let request : NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
//                    do{
//                        let all = try self.coreData.mainContext.fetch(request)
//                        guard let first = all.first else {
//                            promise(.failure(Errors.empty))
//                            return
//                        }
//                        if let data = first.data{
//                            let decoded = try JSONDecoder().decode(T.self, from: data)
//                            promise(.success(decoded))
//                        }else{
//                            promise(.failure(Errors.decodingFailed))
//                        }
//                    }catch{
//                        promise(.failure(Errors.uncompleted))
//                    }
//                case .teams(let code):
//                    let request : NSFetchRequest<LeagueDetailsEntity> = LeagueDetailsEntity.fetchRequest()
//                    let attribute = "code"
//                    let predicate = NSPredicate(format: "%K == %@",attribute,code)
//                    request.predicate = predicate
//                    do{
//                        let all = try self.coreData.mainContext.fetch(request)
//                        guard let first = all.first else {
//                            promise(.failure(Errors.empty))
//                            return
//                        }
//                        if let data = first.data{
//                            let decoded = try JSONDecoder().decode(T.self, from: data)
//
//                            promise(.success(decoded))
//                        }else{
//                            promise(.failure(Errors.decodingFailed))
//                        }
//                    }catch{
//                        promise(.failure(Errors.uncompleted))
//                    }
//                case .games(let id):
//                    let request : NSFetchRequest<GamesEntity> = GamesEntity.fetchRequest()
//                    let attribute = "id"
//                    let predicate = NSPredicate(format: "%K == %ld",attribute,id)
//                    request.predicate = predicate
//                    do{
//                        let all = try self.coreData.mainContext.fetch(request)
//                        guard let first = all.first else {
//                            promise(.failure(Errors.empty))
//                            return
//                        }
//                        if let data = first.data{
//                            let decoded = try JSONDecoder().decode(T.self, from: data)
//                            promise(.success(decoded))
//                        }else{
//                            promise(.failure(Errors.decodingFailed))
//                        }
//                    }catch{
//                        promise(.failure(Errors.uncompleted))
//                    }
//                    break
//            }
