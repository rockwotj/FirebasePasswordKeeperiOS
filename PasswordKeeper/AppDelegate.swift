//
//  AppDelegate.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 11/25/15.
//  Copyright © 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import Material
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    FIRApp.configure()

    // Configure Google Sign-In
    GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
//    GIDSignIn.sharedInstance().delegate = self  // Done in the LoginViewController

    // Override point for customization after application launch.
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    var mainViewController : UIViewController!

    // To give the iOS status bar light icons & text
    UIApplication.sharedApplication().statusBarStyle = .LightContent

    if FIRAuth.auth()?.currentUser != nil {
      let passwordViewController = storyboard.instantiateViewControllerWithIdentifier("PasswordViewController")
      // Configure the window with the NavigationBarViewController as the root view controller
      mainViewController =  AppNavigationBarViewController(rootViewController: passwordViewController)
    } else {
      mainViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
    }

    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = mainViewController
    window?.makeKeyAndVisible()
    return true
  }

  // For iOS 8.0 and below
  func application(application: UIApplication,
                   openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return GIDSignIn.sharedInstance().handleURL(url,
                                                sourceApplication: sourceApplication,
                                                annotation: annotation)
  }

  // For iOS 9.0 and above
  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    return GIDSignIn.sharedInstance().handleURL(url,
                                                sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
  }


  func handleLogout() {
    GIDSignIn.sharedInstance().signOut()
    try! FIRAuth.auth()!.signOut()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
  }

  func handleLogin() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let passwordViewController = storyboard.instantiateViewControllerWithIdentifier("PasswordViewController")
    let navigationBarViewController = AppNavigationBarViewController(rootViewController: passwordViewController)
    window?.rootViewController = navigationBarViewController
  }

}

extension UIViewController {
  var appDelegate : AppDelegate {
    get {
      return UIApplication.sharedApplication().delegate as! AppDelegate
    }
  }
}

