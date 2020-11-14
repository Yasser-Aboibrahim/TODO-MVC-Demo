//
//  AppDelegate.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let isLoggedIn = UserDefaultsManager.shared().isLoggedIn
        if isLoggedIn == true{
            if UserDefaultsManager.shared().token != nil{
                switchToMainState()
            }
        }else{
            switchToAuthState()
        }
        return true
    }
    
    func switchToMainState() {
        let todoListVC = TodoListVC.create()
        let navigationController = UINavigationController(rootViewController: todoListVC)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .purple
        self.window?.rootViewController = navigationController
    }
    
    func switchToAuthState() {
        let signInVC = SignInVC.create()
        let navigationController = UINavigationController(rootViewController: signInVC)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .purple
        self.window?.rootViewController = navigationController
    }
    
}

extension AppDelegate {
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

