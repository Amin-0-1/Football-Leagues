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

    func fetch<T:Codable>(localEntityType:LocalEntityType)-> Future<T,Error>{

        return Future<T, Error>{ promise in
            switch localEntityType {
                case .leagues:
                    let request : NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
                    do{
                        let all = try self.coreData.mainContext.fetch(request)
                        guard let first = all.first else {
                            promise(.failure(Errors.empty))
                            return
                        }
                        if let data = first.data{
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decoded))
                        }else{
                            promise(.failure(Errors.decodingFailed))
                        }
                    }catch{
                        promise(.failure(Errors.uncompleted))
                    }
                case .teams(let code):
                    let request : NSFetchRequest<LeagueDetailsEntity> = LeagueDetailsEntity.fetchRequest()
                    let attribute = "code"
                    let predicate = NSPredicate(format: "%K == %@",attribute,code)
                    request.predicate = predicate
                    do{
                        let all = try self.coreData.mainContext.fetch(request)
                        guard let first = all.first else {
                            promise(.failure(Errors.empty))
                            return
                        }
                        if let data = first.data{
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            
                            promise(.success(decoded))
                        }else{
                            promise(.failure(Errors.decodingFailed))
                        }
                    }catch{
                        promise(.failure(Errors.uncompleted))
                    }
                case .games(let id):
                    let request : NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
                    do{
                        let all = try self.coreData.mainContext.fetch(request)
                        guard let first = all.first else {
                            promise(.failure(Errors.empty))
                            return
                        }
                        if let data = first.data{
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decoded))
                        }else{
                            promise(.failure(Errors.decodingFailed))
                        }
                    }catch{
                        promise(.failure(Errors.uncompleted))
                    }
                    break
            }
            
        }
    }
    
    private func truncate(entity:LocalEntityType,context:NSManagedObjectContext){
        switch entity {
            case .leagues:
                let fetch: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
                do{
                    let allRecord = try context.fetch(fetch)
                    allRecord.forEach { record in
                        context.delete(record)
                    }
                    try context.save()
                }catch{
                    debugPrint(error)
                }
            case .teams(let code):
                let fetch: NSFetchRequest<LeagueDetailsEntity> = LeagueDetailsEntity.fetchRequest()
                let attribute = "code"
                let predicate = NSPredicate(format: "%K == %@",attribute,code)
                fetch.predicate = predicate
                do{
                    let allRecord = try context.fetch(fetch)
                    allRecord.forEach { record in
                        context.delete(record)
                    }
                    try context.save()
                }catch{
                    debugPrint(error)
                }
            case .games(let id): break
        }
    }
}

extension CoreDataManager{

    enum Errors: Error{
        case empty
        case uncompleted
        case decodingFailed
        
        var localizedDescription:String{
            switch self{
                case .empty:
                    return "data not found locally, so please reconnect to the internet"
                case .uncompleted:
                    return "uncompleted process"
                case .decodingFailed:
                    return "failed to decode data locally"
                    
            }
        }
    }
}
