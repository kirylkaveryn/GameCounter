//
//  AppDelegate.swift
//  GameConter
//
//  Created by Kirill on 25.08.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func rootViewController() -> UIViewController {
        let rootViewController = VCGame()
        return rootViewController
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        loadDataToDefaultsAsArray(data: FillingData.data, defaultsKey: rsDefaultsPlayersData)
        loadDataToDefaultsAsArray(data: GameProgress.data, defaultsKey: rsDefaultsGameProgressData)
    }

}

