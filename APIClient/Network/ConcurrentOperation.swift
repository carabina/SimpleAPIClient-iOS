//
//  ConcurrentOperation.swift
//  iOSAPIComms
//
//  Created by Rich Abery on 22/06/2017.
//  Copyright © 2017 RichAppz. All rights reserved.
//

import Foundation

/* NSOperation doesnt know when an asynchronous transaction actually finishes */
class ConcurrentOperation: Operation {

    override var isAsynchronous: Bool {
        return true
    }

    fileprivate var _executing: Bool = false
    override var isExecuting: Bool {
        get { return _executing }
        set {
            if _executing != newValue {
                self.willChangeValue(forKey: "isExecuting")
                _executing = newValue
                self.didChangeValue(forKey: "isExecuting")
            }
        }
    }

    fileprivate var _finished: Bool = false
    override var isFinished: Bool {
        get { return _finished }
        set {
            if _finished != newValue {
                self.willChangeValue(forKey: "isFinished")
                _finished = newValue
                self.didChangeValue(forKey: "isFinished")
            }
        }
    }

    func completeOperation() {
        isExecuting = false
        isFinished  = true
    }

    override func start() {
        if isCancelled { isFinished = true; return }
        isExecuting = true
        main()
    }
    
}
