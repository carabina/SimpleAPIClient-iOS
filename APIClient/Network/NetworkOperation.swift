//
//  NetworkOperation.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 23/06/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation
import Alamofire

private let VelocityServerError = "com.velocity.server"
public let kUnauthorisedRequest = Notification.Name(rawValue: "com.velocity.unauthorised.notification")

class NetworkOperation: ConcurrentOperation {
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    let networkRequest: URLConvertible
    let parameters: [String: Any]?
    let completion: OperationResponse?
    var method: HTTPMethod = .get

    var manager: SessionManager?
    weak var request: Alamofire.Request?

    //================================================================================
    // MARK: Initalization
    //================================================================================
    
    init(request: URLConvertible, config: URLSessionConfiguration, params: [String: Any]?, completionHandler: OperationResponse?) {
        networkRequest  = request
        completion      = completionHandler
        parameters      = params
        manager         = Alamofire.SessionManager(configuration: config)
        super.init()
    }

    override func main() {
        var encoding: ParameterEncoding = URLEncoding.default
        if method == .post || method == .put || method == .patch {
            encoding = JSONEncoding.default
        }
        
        request = manager?.request(networkRequest, method: method, parameters: parameters, encoding: encoding)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard let status = response.response?.statusCode, status >= 400 else {
                    self.completion?(
                        response.result.value as AnyObject?,
                        response.response?.allHeaderFields as? [String: Any],
                        nil
                    )
                    self.completeOperation()
                    return
                }
                
                if status == 401 {
                    NotificationCenter.default.post(name: kUnauthorisedRequest, object: nil)
                }

                var error: NSError?
                if let errorMsg = response.result.value as? [String: Any] {
                    error = NSError(domain: VelocityServerError, code: status, userInfo: errorMsg)
                }

                self.completion?(nil, nil, error)
                self.completeOperation()
        }
    }

    override func cancel() {
        request?.cancel()
        super.cancel()
    }

}
