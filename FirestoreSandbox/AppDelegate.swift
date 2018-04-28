//
//  AppDelegate.swift
//  FirestoreSandbox
//
//  Created by mono on 2018/04/28.
//  Copyright © 2018 Aquatica Inc. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

        db.collection("users").document("mono")
            .collection("posts")
            .order(by: "createTime", descending: true)
            .getDocuments { (snapshot, error) in
                print(error as Any)
                snapshot!.documents.forEach { doc in
                    print(doc)
                }
        }
        return true
    }
}

extension DocumentSnapshot {
    open override var description: String {
        return "id: \(documentID), data: \(data() ?? [:])"
    }
}

extension DocumentReference {
    open override var description: String {
        return path
    }
}

