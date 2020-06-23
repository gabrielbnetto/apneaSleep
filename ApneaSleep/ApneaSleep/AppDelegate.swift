//
//  AppDelegate.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 03/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import IQKeyboardManagerSwift
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "417873552796-3ud03r2po95p9ed9kf72fk9i3fp523uh.apps.googleusercontent.com"
        IQKeyboardManager.shared.enable = true
        MSAppCenter.start("69604849-536a-4973-baf0-f6c6778aa2ce", withServices: [
            MSAnalytics.self,
            MSCrashes.self,
            MSDistribute.self
        ])
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Required for sign in
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}
