//
//  AppDelegate.swift
//  Pebble
//
//  Created by macbookPro on 14/07/2022.
//

import UIKit
import IQKeyboardManagerSwift
import OneSignal
import Alamofire

let appdelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, OSSubscriptionObserver {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        currentTheme = UserDefaults.standard.string(forKey: "Theme") == "Dark" ? .dark : .light
        let curr = ThemeManager.currentTheme(currentTheme)
        ThemeManager.applyTheme(curr)
        self.registerNotification(application)
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("798a6d1e-a30c-43c2-b475-67f01b39897c")
        OneSignal.add(self)
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        
        
        OneSignal.promptForPushNotifications(userResponse: {  accepted in
            if accepted {
                let state = OneSignal.getDeviceState()
                if let playerId = state?.userId {
                    let url = "account/user"
                    let param: [String: Any] = ["onesignal_player_id": playerId]
                    NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers: nil) { result in
                    }
                }
            }
        }, fallbackToSettings: true)
      
        return true
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges) {
        if !stateChanges.from.isSubscribed && stateChanges.to.isSubscribed {
             print("Subscribed for OneSignal push notifications!")
          }
          print("SubscriptionStateChange: \n\(stateChanges)")

          //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            let url = "account/user"
            let param: [String: Any] = ["onesignal_player_id": playerId]
            NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers: nil) { result in
            }
        }
       }

  
    func registerNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                
            }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        switch UIApplication.shared.applicationState {
        case .active:
            //            print("active")
            
            completionHandler([.sound, .alert, .badge])
            
        default:
            completionHandler([.alert, .sound, .badge])
            
        }
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
       // Get the meeting ID from the original notification.
       completionHandler()
    }

}

