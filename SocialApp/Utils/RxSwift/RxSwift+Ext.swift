//
//  RxSwift+Ext.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import RxSwift


public extension PrimitiveSequence {
    /// Run observable in background thread and back to mainthread
    func runInThread() -> PrimitiveSequence<Trait, Element> {
        return self.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
    }
}


public extension ObservableType {
    /// Run observable in background thread and back to mainthread
    func runInThread() -> Observable<Self.Element> {
        return self.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
    }
}
