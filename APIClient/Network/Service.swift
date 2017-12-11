//
//  Service.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 06/07/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import Alamofire

public typealias OperationResponse = (_ json: AnyObject?, _ headers: [String: Any]?, _ error: NSError?) -> Void

public protocol Service {
    var rootURL: String { get }
    var headers: [String: String] { get set }
    var networkQueue: OperationQueue { get }

    func get(_ request: Request, completion: OperationResponse?)
    func post(_ request: Request, completion: OperationResponse?)
    func delete(_ request: Request, completion: OperationResponse?)
    func put(_ request: Request, completion: OperationResponse?)
    func patch(_ request: Request, completion: OperationResponse?)
}

extension Service {
    
    public func makeRequest(_ method: Alamofire.HTTPMethod, request: Request, completion: OperationResponse? = nil) {
        guard let url = try? "\(request.rootUrl ?? rootURL)\(request.endpoint)".asURL() else { return }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        
        let operation = NetworkOperation(request: url, config:configuration, params: request.parameters, completionHandler: completion)
        operation.method = method
        operation.queuePriority = request.priority
        operation.qualityOfService = request.qualityOfService
        networkQueue.addOperation(operation)
    }
    
}
