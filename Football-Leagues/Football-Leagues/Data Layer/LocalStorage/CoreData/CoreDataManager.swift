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
    func insert<T:Codable>(data:T)->Future<Bool,Error>
    func fetch<T:Codable>(model:LocalFetchType,type:T.Type)-> Future<T,Error>
}
class CoreDataManager:CoreDataManagerProtocol{
    private let coreData = CoreDataStack.getInstance(withModel: AppConfiguration.shared.dataModel)
    
    public static let shared = CoreDataManager()
    private init(){}
    
    func insert<T:Codable>(data: T)-> Future<Bool,Error> {
        return Future<Bool,Error>{ promise in
            let encoded = try? JSONEncoder().encode(data)
            self.coreData.performBackgroundTask { context in
                self.truncate(entity: .leagues, context: context)
                let obj = LeagueEntity(context: context)
                obj.data = encoded
                do{
                    try context.save()
                    promise(.success(true))
                }catch{
                    promise(.failure(error))
                    debugPrint(error)
                }
            }
        }
    }

    func fetch<T:Codable>(model:LocalFetchType,type:T.Type)-> Future<T,Error>{

        return Future<T, Error>{ promise in
            switch model {
                case .Leagues:
                    let request : NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
                    do{
                        let all = try self.coreData.mainContext.fetch(request)
                        guard let first = all.first else {
                            promise(.failure(Errors.empty))
                            return
                        }
                        if let data = first.data{
                            let decoded = try JSONDecoder().decode(type, from: data)
                            promise(.success(decoded))
                        }else{
                            promise(.failure(Errors.decodingFailed))
                        }
                    }catch{
                        promise(.failure(Errors.uncompleted))
                    }
            }
            
            
        }
    }
    
    private func truncate(entity:Entities,context:NSManagedObjectContext){
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
                
        }
        
    }
}

extension CoreDataManager{
    enum Entities:String{
        case leagues = "LeagueEntity"
    }
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
