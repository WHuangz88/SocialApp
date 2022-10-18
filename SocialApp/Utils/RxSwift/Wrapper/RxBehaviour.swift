//
//  RxBehaviour.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import RxSwift
import RxRelay

/// wraps a raw type property with BehaviourRelay, similar to Combine @Published
@propertyWrapper
public class RxBehavior<Value> {
    public var projectedValue: BehaviorRelay<Value> { relay }
    public var wrappedValue: Value { didSet { valueDidChange() } }

    private lazy var relay = BehaviorRelay<Value>(value: wrappedValue)

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    private func valueDidChange() {
        relay.accept(wrappedValue)
    }
}
