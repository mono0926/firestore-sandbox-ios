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

    private lazy var db: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        //        loginAnonymously()
        //        getPosts()
        setUsersMono()
        //        getUsersMono()
        //                setLoggedInUser()
        //        createLoggedInUserPost()

        return true
    }

    private func loginAnonymously() {
        Auth.auth().signInAnonymously { (user, error) in
            print(user as Any)
            print(error as Any)
        }
    }

    private func setLoggedInUser() {
        Auth.auth().signInAnonymously { (user, error) in
            self.db.collection("users").document(user!.uid)
                .setData(["name": "匿名ユーザー2"]) { error in
                    print(error as Any)
            }
        }
    }

    private func createLoggedInUserPost() {
        Auth.auth().signInAnonymously { (user, error) in
            self.db.collection("users").document(user!.uid)
                .collection("posts").document()
                .setData([
                    "title": "匿名ユーザーの記事",
                    "body": "匿名ユーザーの記事本文",
                    "createTime": FieldValue.serverTimestamp()
                ]) { error in
                    print(error as Any)
            }
        }
    }

    private func getPosts() {
        db.collection("posts")
            .order(by: "createTime", descending: true)
            .getDocuments { (snapshot, error) in
                print(error as Any)
                snapshot!.documents.forEach { doc in
                    print(doc)
                }
        }
    }

    private func getUsersMono() {
        db.collection("users").document("mono")
            .getDocument { (snapshot, error) in
                snapshot!.metadata.hasPendingWrites
                print(error as Any)
                print(snapshot as Any)
        }
    }

    private func setUsersMono() {
        db.collection("users").document("mono")
            .setData(["name": "もの3"]) { error in
                print(error as Any)
        }
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



