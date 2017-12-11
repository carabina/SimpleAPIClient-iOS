//
//  ClientExample.swift
//  APIClient
//
//  Created by Rich Abery on 11/12/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation

class ClientExample: Service {
    
    var rootURL = "https://yourdomain.com"
    var headers: [String: String] = [:]
    let networkQueue = OperationQueue()
    
    static let shared = ClientExample()
    
    init() { }
    
    func post(_ request: Request, completion: OperationResponse? = nil) {
        makeRequest(.post, request: request, completion: completion)
    }
    
    func get(_ request: Request, completion: OperationResponse? = nil) {
        makeRequest(.get, request: request, completion: completion)
    }
    
    func delete(_ request: Request, completion: OperationResponse? = nil) {
        makeRequest(.delete, request: request, completion: completion)
    }
    
    func put(_ request: Request, completion: OperationResponse? = nil) {
        makeRequest(.put, request: request, completion: completion)
    }
    
    func patch(_ request: Request, completion: OperationResponse? = nil) {
        makeRequest(.patch, request: request, completion: completion)
    }
    
}
