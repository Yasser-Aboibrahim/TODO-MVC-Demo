//
//  LoginResponse.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let token: String
    let user: UserData
    
    enum CodingKeys: String, CodingKey {
        case token, user
    }
}
