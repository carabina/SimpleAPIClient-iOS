//
//  Extension+NSError.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 11/12/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation

extension NSError {
    
    static var mapping: NSError {
        return NSError(
            domain: MappingServiceErrorDomain,
            code: MappingError.TypeNotArray.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Failed to map JSON",
                NSLocalizedFailureReasonErrorKey: "Input type doesnt match array"]
        )
    }
    
    static var authorization: NSError {
        return NSError(
            domain: ServiceAuthenticationErrorDomain,
            code: 401,
            userInfo: [
                NSLocalizedDescriptionKey: "Failed to authorise the login",
                NSLocalizedFailureReasonErrorKey: "Nothing has been received in the headers to authenticate the user"]
        )
    }
    
}
