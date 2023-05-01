//
//  AppDelegate.swift
//  Playnxt
//
//  Created by cano on 19/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import  Alamofire
import Network
import GoogleMobileAds


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 3.0)
        IQKeyboardManager.shared.enable = true
        UserDefaults.standard.value(forKey: Constant.Token)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        userDefault()
        currentLocation()
        //apiSubscription()
        return true
    }
    
    //MARK: - function
    
    func userDefault(){
        print("token-----", UserDefaults.standard.value(forKey: Constant.Token) ?? "")
        
        print(UserDefaults.standard.bool(forKey: "USER_LOGIN"))
        print("keepSignup",UserDefaults.standard.bool(forKey: "USER_SIGNUP"))
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        var vc: UIViewController?
        let userLogin = UserDefaults.standard.bool(forKey: "USER_LOGIN")
        let userSignup =  UserDefaults.standard.bool(forKey: "USER_SIGNUP")
        
        
        
        if userSignup == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vcLogin = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vcLogin
        }else if userLogin == true {
            let storyboard = UIStoryboard(name: "Tab", bundle: nil)
            let myNav = storyboard.instantiateViewController(withIdentifier: "myNavigation") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = myNav
        }else {
            let newViewController = mainStoryboard.instantiateViewController(withIdentifier: "OnboardingVc") as! OnboardingVc
            let navigationController = UINavigationController(rootViewController: newViewController)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
      
    }
}

//MARK: -

/*func apiSubscription(){
    SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Check_Subscription, method: .post, parameter: nil, objectClass: CheckSubsRespo.self, requestCode: Constant.URL_CONSTANT.Check_Subscription, userToken: nil) { response  in
        if response.status == true {
            print("Response",response)
            self.subs = response.data
            self.commonSub = response.data.subscription
            UserDefaults.standard.setValue(response.data.subscribed, forKey: "SUBSCRIBED")
        }else {
            print("message",response.message)
        }
    }
}*/

//MARK: - Location

var lat : String!
var long : String!
var address:String!

func currentLocation() {
    
    if !Connectivity.isConnectedToInternet {
        //   self.showAlert(message: "Please check your internet connection")
        return
    }
    
    CurrentLocation.sharedInstance.function_GetCurrentLocation { latitude, longitude in
        print("---",latitude,longitude)
        self.lat = latitude
        self.long = longitude
        CurrentLocation.sharedInstance.getAddressFromLattLonn(pdblLatitude: self.lat, pdblLongitude: self.long) { address in
            self.address = address
            print("---",latitude,longitude,address)
            Singleton.sharedInstance.lat = latitude
            Singleton.sharedInstance.long = longitude
        }
    }
}
}

