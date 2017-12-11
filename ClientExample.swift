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
    
    func post(request: Request, completion: OperationResponse? = nil) {
        makeRequest(.post, request: request, completion: completion)
    }
    
    func get(request: Request, completion: OperationResponse? = nil) {
        makeRequest(.get, request: request, completion: completion)
    }
    
    func delete(request: Request, completion: OperationResponse? = nil) {
        makeRequest(.delete, request: request, completion: completion)
    }
    
    func put(request: Request, completion: OperationResponse? = nil) {
        makeRequest(.put, request: request, completion: completion)
    }
    
    func patch(request: Request, completion: OperationResponse? = nil) {
        makeRequest(.patch, request: request, completion: completion)
    }
    
}
