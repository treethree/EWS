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
        
        print(userInfo)
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

