//
//  AppDelegate.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [
                         UIApplication
                             .LaunchOptionsKey: Any
                     ]? = nil) -> Bool {
        true
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DIFactory.sharedControllerHelper.setUp()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance

        return true
    }
}
