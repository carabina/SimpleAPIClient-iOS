//
//  Mappable.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 23/06/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import CoreData

@objc public protocol Mappable: class {
    
    init(context: NSManagedObjectContext)
    
    func map(_ json: [String: Any], context: NSManagedObjectContext?)
    
}
