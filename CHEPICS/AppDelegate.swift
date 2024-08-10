//
//  AppDelegate.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation
import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [
                        UIApplication
                            .LaunchOptionsKey: Any
                     ]? = nil) -> Bool {
                         GADMobileAds.sharedInstance().start(completionHandler: nil)
                         return true
                     }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().standardAppearance = navAppearance

        return true
    }
}
