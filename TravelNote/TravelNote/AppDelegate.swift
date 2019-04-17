//
//  AppDelegate.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/3/21.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    
    

    var window: UIWindow?

    let googleAPIKey = "AIzaSyCpfxEzeDUk6i96FuU8yWPOcGxMlSvpsTc"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        setupJpush(appKey: "b80f04ce8cd964ef642ca0fe", launchOptions: launchOptions)
        Fabric.with([Crashlytics.self])

        FIRApp.configure()

        FIRDatabase.database().persistenceEnabled = true

        GMSServices.provideAPIKey(googleAPIKey)

        GMSPlacesClient.provideAPIKey(googleAPIKey)

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = LaunchViewController()

        window?.makeKeyAndVisible()

//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
//
//            application.registerForRemoteNotifications()
//        }
        
        if #available(iOS 10, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            
        } else if #available(iOS 8, *) {
            // 可以自定义 categories
            JPUSHService.register(
                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                    UIUserNotificationType.sound.rawValue |
                    UIUserNotificationType.alert.rawValue,
                categories: nil)
        } else {
            // ios 8 以前 categories 必须为nil
            JPUSHService.register(
                forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
                    UIRemoteNotificationType.sound.rawValue |
                    UIRemoteNotificationType.alert.rawValue,
                categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: "b80f04ce8cd964ef642ca0fe", channel:"AppStore", apsForProduction: true)

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        setupToken(deviceToken: deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("====================")
        print("\(deviceTokenString)")
    }
    
    // JPUSHRegisterDelegate
    // for iOS 12
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        if let notification = notification {
            if notification.request.trigger is UNPushNotificationTrigger {
                print("从通知界面直接进入应用") // ?????
            }else{
                print("从通知设置界面进入应用")
            }
        }
    }
    
    
    
    
    
    // for iOS 10
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (NSInteger)->Void) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(NSInteger(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    // for iOS 10
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: ()->Void) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
}
