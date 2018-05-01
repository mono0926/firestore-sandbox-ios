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
        //        setUsersMono()
        //        getUsersMono()
        //                setLoggedInUser()
//        createLoggedInUserPost()
        keepUpdatingStatus()

        return true
    }

    private func loginAnonymously() {
        Auth.auth().signInAnonymously { (user, error) in
            print(user as Any)
            print(error as Any)
        }
    }

    private func setLoggedInUser() {
        self.db.collection("users").document(Auth.auth().currentUser!.uid)
            .setData(["name": "匿名ユーザー2"]) { error in
                print(error as Any)
        }
    }

    private func createLoggedInUserPost() {
        self.db.collection("users").document(Auth.auth().currentUser!.uid)
            .collection("posts").document()
            .setData([
                "title": "匿名ユーザーの記事",
                "body": "匿名ユーザーの記事本文",
                "createTime": FieldValue.serverTimestamp()
            ]) { error in
                print(error as Any)
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

    func keepUpdatingStatus() {
        let database = Database.database()
        let uid = Auth.auth().currentUser!.uid
        // ".info/connected"という接続状況に応じて値の変わる特別なパスを監視
        database.reference(withPath: ".info/connected").observe(.value) { snap in
            let connected = snap.value as? Bool ?? false
            print("connected: \(connected)")
            if !connected {
                return
            }
            let statusRef = database.reference().child("status").child(uid)
            // 接続が確立されたら、オフラインになったタイミングで更新したい処理を予約しつつ、
            statusRef.onDisconnectSetValue([
                "state": "offline",
                "lastChanged": ServerValue.timestamp()
            ]) { (error, _) in
                // stateをonlineに変更
                statusRef.setValue([
                    "state": "online",
                    "lastChanged": ServerValue.timestamp()
                    ])
            }
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




