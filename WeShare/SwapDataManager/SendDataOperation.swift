//
//  SendDataOperation.swift
//  WeShare
//
//  Created by 朱国良 on 2023/11/25.
//

import UIKit

final class SendDataOperation: OWSOperation {
    
    let exec: (SendDataOperation) -> Void
    let id: String
    
    init(id: String, exec: @escaping (SendDataOperation) -> Void) {
        self.id = id
        self.exec = exec
        super.init()
    }
    
    override func run() {
        exec(self)
    }
}
