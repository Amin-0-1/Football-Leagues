//
//  CoreDataManager.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    
    private static let shared = CoreDataManager()
    private static var model: String?
    private static var store: StoreType = isRunningTests ? .memory : .sqlite
    private static var isRunningTests: Bool = {
        return ProcessInfo.processInfo.arguments.contains("TESTING")
    }()

    private init() {
        _ = persistentContainer
    }
    
    static func configure(model: String, store: CoreDataManager.StoreType) -> CoreDataManager {
        self.model = model
        return shared
    }
    /// Use this method to set the CoreData model name before initializing the stack.
    static func setModelName(_ name: String) {
        model = name
    }
    /// Perform a task on a background context and execute a completion handler.
    func performBackgroundTask(completion: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            completion(context)
        }
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Private
    
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelName = CoreDataManager.model else {
            assertionFailure("Core data model doesn't exist")
            return .init()
        }
        let persistentContainer = NSPersistentContainer(name: modelName)
        switch Self.store {
            case .memory:
                let description = NSPersistentStoreDescription()
                description.type = NSInMemoryStoreType
                persistentContainer.persistentStoreDescriptions = [description]
            default: break
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Failed to load store: \(error), \(error.userInfo)")
            }
        }
        return persistentContainer
    }()
}

// MARK: - StoreType
extension CoreDataManager {
    enum StoreType {
        case memory
        case sqlite
    }
}
