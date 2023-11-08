//
//  GCNetworkError.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/28.
//

import Foundation

public enum PLNetworkError: Error {
    case responseDecodeError
    case responseCodeError(String, String)
    case responseUnknownError
}
