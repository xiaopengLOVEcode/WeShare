//
//  ObservableProperty.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
final public class ObservableProperty<Element>: ObservableType {
    public var wrappedValue: Element {
        get { relay.value }
        set { relay.accept(newValue) }
    }

    public let projectedValue: Observable<Element>

    private let relay: BehaviorRelay<Element>

    public init(wrappedValue: Element) {
        relay = BehaviorRelay<Element>(value: wrappedValue)
        projectedValue = relay.asObservable()
    }

    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        relay.subscribe(observer)
    }

    fileprivate func accept(_ value: Element) {
        relay.accept(value)
    }
}

public extension ObservableType {
    func bind(to relays: ObservableProperty<Element>...) -> Disposable {
        return bind(to: relays)
    }

    func bind(to relays: ObservableProperty<Element?>...) -> Disposable {
        return map { $0 as Element? }.bind(to: relays)
    }

    private func bind(to relays: [ObservableProperty<Element>]) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                relays.forEach {
                    $0.accept(element)
                }
            case let .error(error):
                break
            case .completed:
                break
            }
        }
    }
}
