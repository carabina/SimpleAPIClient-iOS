//
//  StorageClient.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 17/01/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import CoreData

public class StorageClient {
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    public static let shared = StorageClient()
    
    public enum QueueType {
        case main, background
    }
    
    //================================================================================
    // MARK: Properties
    //================================================================================
    
    public var errorHandler: (Error) -> Void = {_ in }
    public lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: type(of: self))
        if
            let modelURL = bundle.url(forResource: "DataModel", withExtension: "momd"),
            let object = NSManagedObjectModel(contentsOf: modelURL) {
            return object
        }
        return NSManagedObjectModel()
    }()
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel", managedObjectModel: self.managedObjectModel)
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { [weak self] _, error in
            if let error = error {
                NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    public var currentContext: NSManagedObjectContext?
    
    public lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    public lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //================================================================================
    // MARK: Helpers
    //================================================================================
    
    public func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.performAndWait {
            block(self.viewContext)
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    public func mapStruct<T: Persistable, E: NSManagedObject>(object: [E]) -> [T] {
        return object.flatMap({ T.init(entity: $0) })
    }
    
}
