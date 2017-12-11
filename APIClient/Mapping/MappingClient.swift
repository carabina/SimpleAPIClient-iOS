//
//  MappingClient.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 12/07/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation

class MappingClient {

    static let shared = MappingClient()

    internal let mappingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        return queue
    }()

}

internal let MappingServiceErrorDomain = "com.service.mapping"
internal let ServiceAuthenticationErrorDomain = "com.service.authentication"

internal enum MappingError: Int {
    case TypeNotArray = 0
    case TypeNotDictionary = 1
    case PrimaryKeyNotFound = 2
}

extension MappingClient {
    
    class func jsonFailedError(message: String) -> NSError {
        return NSError(
            domain: MappingServiceErrorDomain,
            code: MappingError.TypeNotArray.rawValue,
            userInfo: [NSLocalizedDescriptionKey: "Failed to map JSON",
                       NSLocalizedFailureReasonErrorKey: message]
        )
    }

}
