

import Foundation

public extension Array {

    func splitBy(_ callback: (Element) -> Bool) -> ([Element], [Element]) {
        let l = self.filter { callback($0) }
        let r = self.filter { !callback($0) }
        return (l, r)
    }
}

public extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }

    func element(at index: Int) -> Element? {
        return self[safe: index]
    }

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }

    mutating func append(repeating factory: () -> Element, count: Int) {
        guard count > 0 else { return }
        for _ in 0..<count {
            self.append(factory())
        }
    }

    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({ filter($0) }).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

public extension Array where Element: Collection, Element.Index == Int {
    func element(row: Int, col: Int) -> Element.Element? {
        return row < count && row >= 0 && col < self[row].count && col >= 0 ? self[row][col] : nil
    }
}
