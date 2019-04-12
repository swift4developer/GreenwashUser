//
//  AppDelegate.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 23/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseInstanceID
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var appStatus = Int()
    var lat : String!
    var long : String!
    var locationManager:CLLocationManager!
    var deviceToken = ""
    var imgOfServiceProvider = UIImage()
    let gcmMessageIDKey = "AIzaSyDTOoKeeQtZZHyKXVLSusz7VG4GPi5oWRU"
    var postBookingReqDic = ["address": "",
                       "chilServicedId": "",
                       "fromTime": "",
                       "lattitude": "",
                       "longitude": "",
                       "selectedDate": "",
                       "serviceProviderId": "",
                       "specialInstructions": "",
                       "toTime": "",
                       "ProivderName" : "",
                       "ProviderRating" : "",
                       "serviceInfo" : "",
                       "serviceCharge" : ""
                       ]
    
    //var isFirstLoad = Bool()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //isFirstLoad = true
        //IQKeyboardManager.sharedManager().enable = true
        //IQKeyboardManager.sharedManager().enableAutoToolbar = false
        //IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        GIDSignIn.sharedInstance().delegate = self
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services:\(String(describing: configureError))")
        
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google Map
        GMSServices.provideAPIKey("AIzaSyAGQ2I-WDdvkqR3IGUIbNYiNYBvtmfQFMQ")
            //"AIzaSyBI3ZSRIBCsxyFu7KKU0Os3Vi3vCcncIaQ")
        
        //FireBase
        FIRApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            // FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        determineMyCurrentLocation()
        
        // For iPad
        var storyboard = UIStoryboard()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            case 1334:
                print("iPhone 6/6S/7/8")
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            case 2436:
                print("iPhone X")
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            default:
                print("unknown")
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            }
            
            let defaults = UserDefaults.standard
            defaults.set("iPhone", forKey: "Device")
            defaults.synchronize()
            
            var   supportedInterfaceOrientations : UIInterfaceOrientationMask{
                return  .portrait
            }
        }else {
            print("iPad style UI")
            storyboard = UIStoryboard(name: "iPad", bundle: nil)
            
            let defaults = UserDefaults.standard
            defaults.set("iPad", forKey: "Device")
            defaults.synchronize()
            
            //var   supportedInterfaceOrientations : UIInterfaceOrientationMask{
            //   return  .landscapeRight
            //}
            
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        func shouldAutorotate() -> Bool {
            return true
        }
        
        // display storyboard
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if UIDevice().userInterfaceIdiom == .phone {
            return .portrait
        }
        else {
            return .portrait
        }
    }
    
    //MARK: - Notification Delegates
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("Recvide notification in didReceiveRemoteNotification ",userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        let notificationCount = userInfo[AnyHashable("gcm.notification.notificationCount")] as? String
        if notificationCount != nil {
            //let application1 = UIApplication.shared
            application.applicationIconBadgeNumber = Int(notificationCount!)!
        }
        
        switch application.applicationState {
        case .active:
            //app is currently active, can update badges count here
            appStatus = 1
            break
        case .inactive:
            appStatus = 2
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
            appStatus = 3
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("Recvide notification in fetchCompletionHandler ",userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            //UserDefaults.standard.set(refreshedToken , forKey: "deviceToken")
            deviceToken = refreshedToken
            print("Token",deviceToken)
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        /*let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         print("Device Token ",deviceTokenString)
         UserDefaults.standard.set(deviceTokenString , forKey: "deviceToken")*/
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    //MARK: - gettinmg current location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        /*let userLocation:CLLocation = CLLocation[0] as CLLocation
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
        print("lat1: ",lat)
        print("long1: ",long)*/
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            
            //locationManager.startUpdatingHeading()
        }
    }
    
    //MARK: - Google sign in Delegate
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            _ = user.profile.givenName
            _ = user.profile.familyName
            _ = user.profile.email
            print("Name \(String(describing: fullName))")
            
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    
    //MARK: - Facebook Delegate
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: nil)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
         FBSDKAppEvents.activateApp()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        determineMyCurrentLocation()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
        
        print("lat: ",lat)
        print("long: ",long)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    


}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
   
        completionHandler(.alert);
        //  completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Application in background mode. Active / In Active (it open the splash)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        /*/Called when you tap on notification.
        let aps = userInfo[AnyHashable("aps")] as? NSDictionary
        
        let requestID = userInfo[AnyHashable("gcm.notification.requestID")]
        if requestID != nil {
            notificationDic["requestID"] = requestID as? String
        }
        let actionFlag = userInfo[AnyHashable("gcm.notification.actionFlag")] as? String
        let lnderResID = userInfo[AnyHashable("gcm.notification.lenderrequestID")] as? String
        if actionFlag != nil {
            notificationDic["actionFlag"] = actionFlag
            if actionFlag == "20" {
                notificationDic["lenderrequestID"] = lnderResID
            }
            else {
                notificationDic["lenderrequestID"] = "0"
            }
        }
        let notificationCount = userInfo[AnyHashable("gcm.notification.notificationCount")] as? String
        if notificationCount != nil {
            notificationDic["notificationCount"] = notificationCount
            UserDefaults.standard.set(notificationCount, forKey: "notificatoin_count")
            UserDefaults.standard.synchronize()
            print("AppDelegate Count: ",notificationCount ?? "0.")
            
            //let application1 = UIApplication.shared
            //application1.applicationIconBadgeNumber = notificationCount
        }
        let login = userInfo[AnyHashable("gcm.notification.login")] as? String
        if login != nil {
            notificationDic["login"] = login
        }
        let userID = userInfo[AnyHashable("gcm.notification.userID")] as? String
        if userID != nil {
            notificationDic["userID"] = userID
        }
        
        let alert = aps?["alert"] as? NSDictionary
        let body = alert?["body"] as? String
        if body != nil {
            notificationDic["body"] = body
        }
        let title = alert?["title"] as? String
        if title != nil {
            notificationDic["title"] = title
        }
         if appStatus == 1 {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyNotification"), object: nil, userInfo: notificationDic)
         }
        */
        
        completionHandler()
    }
    
    //    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    //        print(remoteMessage.appData)
    //    }
}

