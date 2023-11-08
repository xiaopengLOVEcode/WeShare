

import Foundation
import CommonCrypto

public extension String {

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func nsrange(of substring: String) -> NSRange {
        guard let range = range(of: substring) else { return NSRange(location: 0, length: 0) }
        let start = distance(from: startIndex, to: range.lowerBound) as Int
        let end = distance(from: startIndex, to: range.upperBound) as Int
        return NSRange(location: start, length: end - start)
    }

    func stringByAppendingPathComponent(path: String) -> String {
        let nsStr = self as NSString
        return nsStr.appendingPathComponent(path)
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    var md5: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }
    }
}
