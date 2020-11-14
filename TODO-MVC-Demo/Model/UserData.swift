//
//  UserData.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    var id: String
    var name, email: String
    var age: Int
    
    enum CodingKeys: String, CodingKey {
        case age, name, email 
        case id = "_id"
    }
}
