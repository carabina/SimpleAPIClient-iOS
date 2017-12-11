//
//  Persistable.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 19/06/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import CoreData

public protocol Persistable {
    
    associatedtype T: NSManagedObject
    
    init?<T: NSManagedObject>(entity: T)
    
}
