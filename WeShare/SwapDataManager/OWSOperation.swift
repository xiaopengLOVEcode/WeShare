//
//  OWSOperation.swift
//  WeShare
//
//  Created by XP on 2023/11/25.
//

let OWSOperationKeyIsExecuting = "isExecuting"
let OWSOperationKeyIsFinished = "isFinished"

enum OWSOperationState {
    case new
    case executing
    case finished
}

class OWSOperation: Operation {
    
    var operationState: OWSOperationState = .new
        
    override init() {
        super.init()
        operationState = .new
    }
    
    func run() {
        // Your implementation for the bulk of the operation's work
    }
    
    func didSucceed() {
        // no-op
        // Override in subclass if necessary
    }
    
    func didCancel() {
        // no-op
        // Override in subclass if necessary
    }
    
    func didReportError(_ error: Error) {
        // no-op
        // Override in subclass if necessary
    }
    
    func didFailWithError(_ error: Error) {
        // no-op
        // Override in subclass if necessary
    }
    
    func didComplete() {
        // no-op
        // Override in subclass if necessary
    }
    
    // MARK: - NSOperation Overrides
    
    override func main() {
        if isCancelled {
            reportCancelled()
            return
        }
        run()
    }
    
    // MARK: - Public Methods
    
    func reportSuccess() {
        didSucceed()
        markAsComplete()
    }
    
    func reportCancelled() {
        didCancel()
        markAsComplete()
    }
    
    func reportError(_ error: Error) {
        didReportError(error)
    }
    
    // MARK: - Life Cycle
    
    func failOperationWithError(_ error: Error) {
        didFailWithError(error)
        markAsComplete()
    }
    
    override var isExecuting: Bool {
        return operationState == .executing
    }
    
    override var isFinished: Bool {
        return operationState == .finished
    }
    
    override func start() {
        operationState = .executing
        super.start()
    }
    
    func markAsComplete() {
        willChangeValue(forKey: OWSOperationKeyIsExecuting)
        willChangeValue(forKey: OWSOperationKeyIsFinished)
        
        // Ensure we call the success or failure handler exactly once.
        objc_sync_enter(self)
        operationState = .finished
        objc_sync_exit(self)
        
        didChangeValue(forKey: OWSOperationKeyIsExecuting)
        didChangeValue(forKey: OWSOperationKeyIsFinished)
        didComplete()
    }
}
