//
//  CommonConstants.swift
//  PowerLoans
//
//  Created by Neo on 2023/9/6.
//

import Foundation

public class CommonConstants: NSObject {
    public static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
}
