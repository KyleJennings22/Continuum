//
//  AppDelegate.swift
//  Continuum
//
//  Created by DevMountain on 2/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    func checkStatus(completion: @escaping (Bool) -> Void) {
      CKContainer.default().accountStatus { (status, error) in
        if let error = error {
          print("Account status error:", error.localizedDescription)
        }
        switch status {
        case .available:
          return completion(true)
        case .couldNotDetermine:
          self.window?.rootViewController?.presentSimpleAlertWith(title: "Error", message: "Could not determine iCloud account status")
          return completion(false)
        case .noAccount:
          self.window?.rootViewController?.presentSimpleAlertWith(title: "Error", message: "You are not logged into iCloud")
          return completion(false)
        case .restricted:
          self.window?.rootViewController?.presentSimpleAlertWith(title: "Error", message: "Account restricted")
          return completion(false)
        default:
          self.window?.rootViewController?.presentSimpleAlertWith(title: "Error", message: "Could not determine error")
          return completion(false)
        }
      }
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

extension UIViewController {
  func presentSimpleAlertWith(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
    alertController.addAction(okayAction)
    self.present(alertController, animated: true)
  }
}
