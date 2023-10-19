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
    func insert(competitions: [Competition])
}
class CoreDataManager:CoreDataManagerProtocol{
    
    enum Entities:String{
        case leagues = "LeagueEntity"
    }
    
    private let coreData = CoreDataStack.getInstance(withModel: AppConfiguration.shared.dataModel)
    
    public static let shared = CoreDataManager()
    private init(){}
    func insert(competitions: [Competition]) {
        
        coreData.performBackgroundTask { context in
            context.performAndWait {
                self.truncate(entity: .leagues, context: context)
                competitions.forEach { competition in
                    let obj = LeagueEntity(context: context)
                    obj.area = competition.area?.code
                    obj.code = competition.code
                    obj.imageUrl = competition.emblem
                    obj.name = competition.name
                    obj.numberOfSessons = Int16(competition.numberOfAvailableSeasons ?? 0)
                    obj.type = competition.type
                }
                do{
                    try context.save()
                }catch{
                    print(error)
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
