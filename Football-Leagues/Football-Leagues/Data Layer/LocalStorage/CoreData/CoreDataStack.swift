//
//  CoreDataStack.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import Foundation
import CoreData
import Combine


// MARK: - Context
extension CoreDataStack{
    enum Context{
        case memory
        case physical
    }
}

public class CoreDataStack{
        
    /// get the only single shared instance of CoreDataStack
    /// - Parameters:
    ///   - model: DataModelName.xctdatamodel
    ///   - context: Either save data physically or in the memory
    /// - Returns: CoreDataStack shared instance
    static func getInstance(withModel model:String,context:CoreDataStack.Context = .physical)->CoreDataStack{
        self.modelName = model
        context == .memory ? prepareForTesting() : prepareForProduction()
      return shared
    }
    private static let shared = CoreDataStack()
    private static var modelName:String!
    private init(){}
    
    private static func prepareForTesting(){
        shared.persistentContainer = NSPersistentContainer(name: Self.modelName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        shared.persistentContainer.persistentStoreDescriptions = [description]
        shared.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load store: \(error), \(error.userInfo)")
            }
        }
    }
    
    private static func prepareForProduction(){
        _ = shared.persistentContainer
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
//    var backgroundContext:NSManagedObjectContext{
//        return persistentContainer.newBackgroundContext()
//    }
//
    func performBackgroundTask(completion:@escaping(NSManagedObjectContext)->Void) {
        persistentContainer.performBackgroundTask { context in
            completion(context)
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Self.modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
        
    func saveContext() {
        
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
