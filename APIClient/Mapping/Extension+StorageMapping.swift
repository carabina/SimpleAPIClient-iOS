//
//  Extension+StorageMapping.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 23/01/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import CoreData

extension StorageClient {
    
    //================================================================================
    // MARK: Mapping
    //================================================================================
    
    fileprivate func getId(jsonId: Any?) -> String? {
        if let identifier = jsonId as? String {
            return identifier
        } else if let identifier = jsonId as? Int {
            return "\(identifier)"
        }
        return nil
    }
    
    public func map<T>(_ json: Any?, save: Bool = true, block: @escaping (_ object: T?, _ error: NSError?) -> Void) where T: Mappable, T: Identifiable, T: NSManagedObject {
        var error: NSError?
        var result: T?
        if
            let json = json as? [String: Any],
            let identifier = self.getId(jsonId: json["\(T.identifier)"]) {
            
            self.performBackgroundTask({ (context) in
                context.undoManager = nil
                
                if let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
                    request.predicate = NSPredicate(format: "\(T.identifier) == %@", identifier)
                    do {
                        let results = try context.fetch(request)
                        if let item = results.first {
                            item.map(json, context: context)
                            result = item
                        } else {
                            let item = T.self(context: context)
                            item.map(json, context: context)
                            result = item
                        }
                        
                        if save {
                            try context.save()
                        }
                        
                    } catch let err as NSError {
                        error = err
                    }
                }
                
                block(result, error)
            })
            
        } else {
            block(nil, .mapping)
        }
    }
    
    public func map<T>(_ json: Any?, save: Bool = true, block: @escaping (_ object: [T]?, _ error: NSError?) -> Void) where T: Mappable, T: Identifiable, T: NSManagedObject {
        var identifiers = [String]()
        var idResults = [T]()
        var error: NSError?
        
        if let array = json as? [[String : Any]] {
            for item in array {
                if let id = self.getId(jsonId: item["\(T.identifier)"]) { identifiers.append(id) }
            }
            
            self.performBackgroundTask({ context in
                if let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
                    request.predicate = NSPredicate(format: "\(T.identifier) IN %@", identifiers)
                    do {
                        let results = try context.fetch(request)
                        if identifiers.count == results.count {
                            idResults = results
                        } else {
                            for id in identifiers {
                                if let result = results.filter({ $0.value(forKey: T.identifier) as? String == id }).first {
                                    idResults.append(result)
                                } else {
                                    idResults.append(T.self(context: context))
                                }
                            }
                        }
                        
                        var index: Int = 0
                        for r in idResults {
                            r.map(array[index], context: context)
                            if let indexable = r as? IndexMappable {
                                indexable.displayIndex = Int32(index)
                            }
                            index += 1
                        }
                        
                        if save {
                            try context.save()
                        }
                        
                    } catch let err as NSError {
                        error = err
                    }
                }
                block(idResults, error)
            })
            
        } else {
            block(nil, .mapping)
        }
    }
    
    // Saving an array of child objects for a parent
    public func map<T>(_ json: Any?, context: NSManagedObjectContext?, block: @escaping (_ object: [T]?, _ error: NSError?) -> Void) where T: Mappable, T: NSObject {
        if let array = json as? [[String : Any]], let context = context {
            
            var TArray = [T]()
            for item in array {
                let object = T.self(context: context)
                object.map(item, context: context)
                TArray.append(object)
            }
            block(TArray, nil)
        } else {
            block(nil, .mapping)
        }
    }
    
    //================================================================================
    // MARK: Quick Functions
    //================================================================================
    
    public func retrieve<T>(queue: QueueType = .background, _ completion: @escaping (([T]?) -> Void)) where T: Persistable, T: Identifiable {
        performBackgroundTask { (context) in
            let request = NSFetchRequest<T.T>(entityName: String(describing: T.T.self))
            
            do {
                let results = try context.fetch(request)
                let resultsArray: [T]? = self.mapStruct(object: results)
                
                switch queue {
                case .main:
                    DispatchQueue.main.async {
                        completion(resultsArray)
                    }
                case .background:
                    completion(resultsArray)
                }
            } catch {
                switch queue {
                case .main:
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                case .background:
                    completion(nil)
                }
            }
        }
    }
    
    public func retrieve<T>(_ id: String?, queue: QueueType = .background, _ completion: @escaping ((T?) -> Void)) where T: Persistable, T: Identifiable {
        performBackgroundTask { (context) in
            let request = NSFetchRequest<T.T>(entityName: String(describing: T.T.self))
            request.predicate = NSPredicate(format: "\(T.identifier) == %@", id ?? "")
            
            func returnNil() {
                switch queue {
                case .main:
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                case .background:
                    completion(nil)
                }
            }
            
            do {
                let results = try context.fetch(request)
                if let object = results.first, let t = T.init(entity: object) {
                    switch queue {
                    case .main:
                        DispatchQueue.main.async {
                            completion(t)
                        }
                    case .background:
                        completion(t)
                    }
                } else {
                    returnNil()
                }
            } catch {
                returnNil()
            }
        }
    }
    
    public func retrieve<T>(_ id: String?, _ completion: @escaping ((T?) -> Void)) where T: Mappable, T: Identifiable, T: NSManagedObject {
        performBackgroundTask { (context) in
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = NSPredicate(format: "\(T.identifier) == %@", id ?? "")
            
            func returnNil() {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            do {
                let results = try context.fetch(request)
                if let object = results.first {
                    DispatchQueue.main.async {
                        completion(object)
                    }
                } else {
                    returnNil()
                }
            } catch {
                returnNil()
            }
        }
    }
    
    //================================================================================
    // MARK: Mapping Quick Objects
    //================================================================================
    
    public func create<T>(_ data: Any?) -> T? where T: Mappable {
        guard let data = data as? [String: Any] else { return nil }
        
        let context = viewContext
        let obj = T.self(context: context)
        obj.map(data, context: context)
        
        return obj
    }
    
    public func create<T>(_ data: Any?) -> [T]? where T: Mappable {
        guard let data = data as? [[String: Any]] else { return nil }
        
        var objects = [T]()
        let context = viewContext
        for d in data {
            let obj = T.self(context: context)
            obj.map(d, context: context)
            objects.append(obj)
        }
        return objects
    }
    
}

