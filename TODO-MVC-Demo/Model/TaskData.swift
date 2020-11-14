//
//  Data.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/31/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation

struct TaskData: Codable{
    var description: String!
    var id: String!
    
    enum CodingKeys: String, CodingKey {
        case description
        case id = "_id"
    }

}

