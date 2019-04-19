//
//  AppDelegate.swift
//  EWS
//
//  Created by SHILEI CUI on 4/8/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
import GooglePlaces
import GoogleMaps
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import FirebaseMessaging


var lat : Double = 0
var lot : Double = 0
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate, MessagingDelegate{

    var window: UIWindow?
    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(client_key)
        GMSServices.provideAPIKey(client_key)
        
        FirebaseApp.configure()
        //for notification
        let setting = UNUserNotificationCenter.current()
        setting.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            
            if granted{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }else{
                
            }
            Messaging.messaging().delegate = self
            Messaging.messaging().isAutoInitEnabled = true
            Messaging.messaging().shouldEstablishDirectChannel = true
            Messaging.messaging().subscribe(toTopic: "Another Test Topic")
        }
        
        setupLocation()
        if (Auth.auth().currentUser != nil) {
            let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            self.window?.rootViewController = ctrl
        }
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)

 
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let varAvgvalue = String(format: "%@", deviceToken as CVarArg)
        
        let  token = varAvgvalue.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
        
        print(token)
        //Application token will remain same unless you delete your application.
        //50c199a0a24bb904706dd46cf81521661dfebd68b7fb36d8fa3f379d3e0b651b
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //print(userInfo)
        guard let userInfo = userInfo as? [String : Any],
            let senderID = userInfo["gcm.notification.sender"] as? String,
            let aps = userInfo["aps"] as? [String : Any],
            let alert = aps["alert"] as? [String : Any],
            let message = alert["body"] as? String else { return }

        if let root = window?.rootViewController as? UITabBarController,
            root.selectedIndex == 3,
            let chatNav = root.viewControllers?[3] as? UINavigationController,
            let currentVC = chatNav.visibleViewController as? ChatViewController,
            senderID == currentVC.singleFriendInfo!.uid {
            let uid = Auth.auth().currentUser?.uid
            let chatInfo = ChatInfo(msg: message, receiver: uid!)
            currentVC.addRow(chatInfo)
        }
        
//        guard let userInfo = userInfo as? [String : Any],
//            let senderID = userInfo["gcm.notification.sender"] as? String,
//            let aps = userInfo["aps"] as? [String : Any],
//            let alert = aps["alert"] as? [String : Any],
//            let message = alert["body"] as? String else { return }
//
//        if let root = window?.rootViewController as? UITabBarController,
//            root.selectedIndex == 3,
//            let chatNav = root.viewControllers?[3] as? UINavigationController,
//            let currentVC = chatNav.visibleViewController as? ChatViewController,
//            senderID == currentVC.singleFriendInfo!.uid {
//            let uid = Auth.auth().currentUser?.uid
//            let chatInfo = ChatInfo(msg: message, receiver: uid!)
//            currentVC.addRow(chatInfo)
//        }
    }
    
    // Messaging Delegate
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        print(remoteMessage.appData)
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //Messaging.messaging().apnsToken = fcmToken
        
        print("token : \(fcmToken)")
    }
    

    func application(_ application: UIApplication, open url: URL, sourceApplication:  String?, annotation: Any) -> Bool {
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                sourceApplication: sourceApplication,
                                                                annotation: annotation)
        return googleDidHandle || facebookDidHandle
    }


    
    func setupLocation(){
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            lat = loc.coordinate.latitude
            lot = loc.coordinate.longitude
            print(lat,lot)
            locationManager.stopUpdatingLocation()
        }
    }


}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func setupNotifications() {
        let setting = UNUserNotificationCenter.current()
        setting.delegate = self
        setting.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            
            if granted{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }else{
                
            }
            
            Messaging.messaging().delegate = self
            Messaging.messaging().isAutoInitEnabled = true
            Messaging.messaging().shouldEstablishDirectChannel = true
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if let userInfo = response.notification.request.content.userInfo as? [String : Any] {
            navToChat(with: userInfo)
        }

        completionHandler()
    }
    func navToChat(with userInfo: [String: Any]) {
        // Getting user info
        print(userInfo)
        let chatStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let senderId = userInfo["gcm.notification.sender"] as? String,
            let targetVC = chatStoryboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatViewController,
            let root = window?.rootViewController as? UITabBarController,
            let chatNav = root.viewControllers?[3] as? UINavigationController,
            let friendsVC = chatNav.viewControllers[0] as? FriendsViewController,
            !(chatNav.visibleViewController is ChatViewController) {
            
            var receiver: UserModel!
            for friend in friendsVC.users {
                if friend.uid == senderId {
                    receiver = friend
                }
            }
            
            if receiver == nil {
                receiver =  UserModel(senderId, info: [:])
            }
            
            targetVC.singleFriendInfo = receiver
            chatNav.present(targetVC, animated: true)
            root.selectedIndex = 3
        }
    }
    
//    func navToChat(with userInfo: [String: Any]) {
//        // Getting user info
//        print(userInfo)
//        let chatStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        if let senderId = userInfo["gcm.notification.sender"] as? String,
//            let targetVC = chatStoryboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC,
//            let root = window?.rootViewController as? UITabBarController,
//            let chatNav = root.viewControllers?[2] as? UINavigationController,
//            let friendsVC = chatNav.viewControllers[0] as? FriendsVC,
//            !(chatNav.visibleViewController is ChatVC) {
//
//            var receiver: UserInfo!
//            for friend in friendsVC.userList {
//                if friend.uid == senderId {
//                    receiver = friend
//                }
//            }
//
//            if receiver == nil {
//                receiver =  UserInfo(senderId)
//            }
//
//            targetVC.friend = receiver
//            chatNav.present(targetVC, animated: true)
//            root.selectedIndex = 2
//        }
//    }
}
