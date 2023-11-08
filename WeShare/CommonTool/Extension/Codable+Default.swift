//
//  Codable+Default.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/28.
//

import Foundation

public protocol DecodableDefaultValue {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

public extension Bool {
    enum False: DecodableDefaultValue {
        public static let defaultValue = false
    }
    enum True: DecodableDefaultValue {
        public static let defaultValue = true
    }
}

public extension String {
    enum Empty: DecodableDefaultValue {
        public static let defaultValue = ""
    }
}

public extension Int {
    enum Zero: DecodableDefaultValue {
        public static let defaultValue: Int = 0
    }
    enum NegativeOne: DecodableDefaultValue {
        public static let defaultValue: Int = -1
    }
}

public extension Int64 {
    enum Zero: DecodableDefaultValue {
        public static let defaultValue: Int64 = 0
    }
    enum NegativeOne: DecodableDefaultValue {
        public static let defaultValue: Int64 = -1
    }
}

// MARK: - DecodableDefault PropertyWrapper

@propertyWrapper
public struct DecodableDefault<T: DecodableDefaultValue> {
    public var wrappedValue: T.Value

    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension DecodableDefault: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault<T>.Type, forKey key: Key) throws -> DecodableDefault<T> where T: DecodableDefaultValue {
        try decodeIfPresent(type, forKey: key) ?? DecodableDefault(wrappedValue: T.defaultValue)
    }
}
