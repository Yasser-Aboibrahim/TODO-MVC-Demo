//
//  Constants.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation

// Storyboards
struct Storyboards {
    static let authentication = "Authentication"
    static let main = "Main"
}

// View Controllers
struct ViewControllers {
    static let signUpVC = "SignUpVC"
    static let signInVC = "SignInVC"
    static let todoListVC = "TodoListVC"
    static let profileVC = "ProfileVC"
    
}

// Urls

struct URLs {
//    static let base = "https://api-nodejs-todolist.herokuapp.com"
//    static let login = base + "/user/login"
//    static let register = base + "/user/register"
//    static let userData = base + "/user/me"
//    static let logOut = base + "/user/logout"
//    static let task = base + "/task"
//    static let uploadImage = base + "/user/me/avatar"
    
    static let base = "https://api-nodejs-todolist.herokuapp.com"
    static let login = "/user/login"
    static let register = "/user/register"
    static let userData = "/user/me"
    static let logOut = "/user/logout"
    static let task = "/task"
    static let uploadImage = base + "/user/me/avatar"
    static let uploadImageRouter = "/user/me/avatar"
    
}

// Header Keys
struct HeaderKeys {
    static let contentType = "Content-Type"
    static let Authorization = "Authorization"
}

// Parameters Keys
struct ParameterKeys {
    static let email = "email"
    static let password = "password"
    static let name = "name"
    static let age = "age"
    static let description = "description"
    static let avatar = "avatar"
}

// UserDefaultsKeys
struct UserDefaultsKeys {
    static let token = "UDKToken"
    static let isLoggedIn = "IsLoggedIn"
    static let userId = "userId"
    static let taskId = "taskId"
    
}

struct Cells{
    static var TodoCell = "TodoCell"
}
