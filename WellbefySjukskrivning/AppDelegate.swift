//
//  AppDelegate.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationDelegate = NotificationDelegate()
    
    var APP_ID = ""
    var API_KEY = ""
    
    var backendless = Backendless.sharedInstance()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //Push notification request and delegate
        let center = UNUserNotificationCenter.current()
        let options = UNAuthorizationOptions([.alert, .sound, .badge])
        center.requestAuthorization(options: options, completionHandler: {granted, error in
            if let aError = error {
                debugPrint(aError.localizedDescription)
            } else {
                if granted != true {
                    debugPrint("user doesn't permit notifications")
                }
            }
        })
        center.delegate = notificationDelegate
        
        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let values = keys {
            APP_ID = values["APP_ID"] as! String
            API_KEY = values["API_KEY"] as! String
            backendless?.initApp(APP_ID, apiKey:API_KEY)
        }
      
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

