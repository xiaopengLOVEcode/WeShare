
import Foundation
import RxSwift
import RxCocoa

// MARK: pipe

public extension PublishSubject {
    static func pipe() -> (Observable<Element>, AnyObserver<Element>) {
        let subject = PublishSubject<Element>()
        return (subject.asObservable(), subject.asObserver())
    }
}

// MARK: SubscribeNext

public extension ObservableType {
    func subscribeNext(_ closure: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: closure)
    }

    func subscribeError(_ closure: @escaping (Error) -> Void) -> Disposable {
        return self.subscribe(onError: closure)
    }

    func subscribeCompleted(_ closure: @escaping () -> Void) -> Disposable {
        return self.subscribe(onCompleted: closure)
    }
}

public extension ControlEvent {
    @discardableResult
    func subscribeNext(_ closure: @escaping (PropertyType) -> Void) -> Disposable {
        return self.subscribe(onNext: closure)
    }
}

// MARK: Map

public extension ObservableType {
    func mapReplace<R>(_ output: R) -> Observable<R> {
        return map { _ in output }
    }
}

// MARK: Filter

public extension ObservableType where Element: Equatable {
    func ignore(_ value: Element) -> Observable<Element> {
        return filter { $0 != value }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

public extension ObservableType where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return compactMap { $0.optional }
    }
}

// MARK: And / Or / Not

public extension ObservableType where Element == (Bool, Bool) {
    func and() -> Observable<Bool> {
        return map { $0 && $1 }
    }
}
public extension ObservableType where Element == (Bool, Bool, Bool) {
    func and() -> Observable<Bool> {
        return map { $0 && $1 && $2 }
    }
}
public extension ObservableType where Element == (Bool, Bool, Bool, Bool) {
    func and() -> Observable<Bool> {
        return map { $0 && $1 && $2 && $3 }
    }
}

public extension ObservableType where Element == (Bool, Bool) {
    func or() -> Observable<Bool> {
        return map { $0 || $1 }
    }
}
public extension ObservableType where Element == (Bool, Bool, Bool) {
    func or() -> Observable<Bool> {
        return map { $0 || $1 || $2 }
    }
}
public extension ObservableType where Element == (Bool, Bool, Bool, Bool) {
    func or() -> Observable<Bool> {
        return map { $0 || $1 || $2 || $3 }
    }
}

public extension ObservableType where Element == Bool {
    func not() -> Observable<Bool> {
        return self.map { !$0 }
    }
}
