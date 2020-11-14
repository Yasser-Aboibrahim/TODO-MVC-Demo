//
//  UserDefaultsManager.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation


class UserDefaultsManager {
    
    // MARK:- Singleton
    private static let sharedInstance = UserDefaultsManager()
    
    class func shared() -> UserDefaultsManager {
        return UserDefaultsManager.sharedInstance
    }
    
    // MARK:- Properties
    
    var isLoggedIn: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isLoggedIn)
        }
        get{
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn)
        }
    }
    
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.token)
        }
        get {
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.token) != nil else {
                return nil
            }
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.token)!
        }
    }
    
    var userId: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userId)
        }
        get {
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.userId) != nil else {
                return nil
            }
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)!
        }
    }
    
    var taskId: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.taskId)
        }
        get {
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.taskId) != nil else {
                return nil
            }
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.taskId)!
        }
    }
}
