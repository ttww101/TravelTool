//
//  SetupJpush.swift
//  swift jpush
//
//  Created by Apple on 2019/4/11.
//  Copyright © 2019年 Apple. All rights reserved.
//

import AVOSCloud
import UserNotificationsUI
import UserNotifications

func setupToken(deviceToken: Data) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
    JPUSHService.registerDeviceToken(deviceToken)
}

func setupJpush(appKey: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    // setup 極光
    // 初始化 APNs
    if #available(iOS 10, *) {
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: JPUSHRegister())
        
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
    
    JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel:"AppStore", apsForProduction: true)
    
}

class JPUSHRegister : NSObject, JPUSHRegisterDelegate {
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
