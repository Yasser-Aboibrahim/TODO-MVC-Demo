//
//  UserImage.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/4/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit

struct UserImage: Codable{
    var avatar: Data!
    
}

struct CodableImage: Codable{
    var imageData: Data?
    
    static func setImage(image: UIImage) -> Data? {
        let data = image.jpegData(compressionQuality: 0.2)
        return data
    }
    
    static func getImage(imageData: Data?)-> UIImage?{
        guard let Data = imageData else {
            return nil
        }
        let image = UIImage(data: Data)
        return image
    }
}
