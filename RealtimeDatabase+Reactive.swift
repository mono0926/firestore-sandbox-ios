//
//  RealtimeDatabase+Reactive.swift.swift
//  FirestoreSandbox
//
//  Created by mono on 2018/05/01.
//  Copyright © 2018 Aquatica Inc. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

private let database = Database.database()

extension Reactive where Base: DatabaseReference {
    func onDisconnectSet(value: Any?) -> Single<()> {
        return .create { observer in
            self.base.onDisconnectSetValue(value) { error, _ in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    func observerValue() -> Observable<Bool> {
        return .create { observer in
            self.base.observe(.value) { snapshot in
                let value = snapshot.value as? Bool ?? false
                print("value: \(value)")
                observer.on(.next(value))
            }
            return Disposables.create()
        }
    }
}
