//
//  AppDelegate.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 31.08.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AuthServiceDelegate {

    var authService: AuthService!
    var window: UIWindow?
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        authService = AuthService()
        authService.delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
//        return true
        
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let vkSdkResult = VKSdk.processOpen(url, fromApplication: sourceApplication)
        return vkSdkResult
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    MARK: -- AuthServiceDelegate

    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print(#function)
        let feedVC: NewsfeedViewController = NewsfeedViewController.loadFromStoryboard()
        
        let navigationVc = UINavigationController(rootViewController: feedVC)
        
        UIApplication.shared.windows.first?.rootViewController = navigationVc
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func authServiceDidSignInFailed() {
        
    }
}

