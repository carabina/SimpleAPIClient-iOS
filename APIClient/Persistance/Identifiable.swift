//
//  Identifiable.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 19/06/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import CoreData

public protocol Identifiable {
    
    static var identifier: String { get }
    
}
