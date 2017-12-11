//
//  Request.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 04/07/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import Alamofire

public enum RootUrl: String {
    case StagingUncover = "https://reserve-api-staging.velocityapp.com"
    case Uncover = "https://api-eu-west.uncoverdining.com"
    case StagingVelocity = "https://mobile-dev.paywithvelocity.com"
    case Velocity = "https://mobile.paywithvelocity.com"
}

open class Request {
    
    //================================================================================
    // MARK: Properties
    //================================================================================
    
    open var rootUrl: String?
    open var endpoint: String
    open var parameters: [String: Any]?
    open var priority: Operation.QueuePriority
    open var qualityOfService: QualityOfService
    
    //================================================================================
    // MARK: Initialization
    //================================================================================
    
    public init(endpoint: String, parameters: [String: Any]? = nil, priority: Operation.QueuePriority?, qualityOfService: QualityOfService?) {
        self.endpoint = endpoint
        self.parameters = parameters
        self.priority = priority ?? .veryHigh
        self.qualityOfService = qualityOfService ?? .userInitiated
    }
    
}
