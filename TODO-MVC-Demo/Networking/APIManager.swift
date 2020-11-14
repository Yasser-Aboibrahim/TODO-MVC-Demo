//
//  APIManager.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

class APIManager {

    
    class func loginAPIRouter(email: String, password: String, completion: @escaping (Result<LoginResponse,Error>) -> Void){
        request(APIRouter.login(email, password)) { (response) in
            completion(response)
            
        }
    }
    
    class func registerAPIRouter(email: String, password: String, name: String, age: Int, completion: @escaping (Result<LoginResponse,Error>) -> Void){
        request(APIRouter.register(email, password, name ,age)) { (response) in
            completion(response)
            
        }
    }
    
    class func updateUserDataAPIRouter(age: Int, completion: @escaping (Result<UserData,Error>) -> Void){
        request(APIRouter.updateUserData(age)) { (response) in
            completion(response)
            
        }
    }
    
    class func addTaskAPIRouter(description: String, completion: @escaping (Result<TaskData,Error>) -> Void){
        request(APIRouter.addTask(description)) { (response) in
            completion(response)
            
        }
    }
    
    class func getUserTasksAPIRouter(completion: @escaping (Result<Task?,Error>) -> Void){
        request(APIRouter.getUserTasks) { (response) in
            completion(response)
            
        }
    }
    
    class func getUserDataAPIRouter(completion: @escaping (Result<UserData,Error>) -> Void){
        request(APIRouter.getUserData) { (response) in
            completion(response)
            
        }
    }
    
    class func logOutUserAPIRouter(completion: @escaping (Result<UserData,Error>) -> Void){
        request(APIRouter.logout) { (response) in
            completion(response)
            
        }
    }
    
    class func deleteTaskAPIRouter(completion: @escaping (Result<TaskData,Error>) -> Void){
        request(APIRouter.deleteTask) { (response) in
            completion(response)
            
        }
    }
    
    
    
    class func uploadUserImage(userImage: UIImage ,completion: @escaping (_ error: Error?) -> Void) {
        
        let userToken = UserDefaultsManager.shared().token
        let headers: HTTPHeaders = [HeaderKeys.Authorization: "Bearer \(userToken ?? "")"]
        
        AF.upload(multipartFormData: { (form) in
            
            if let data = CodableImage.setImage(image: userImage){
            form.append(data, withName: "avatar",fileName: "/home/ali/Mine/c/nodejs-blog/public/img/blog-header.jpg" , mimeType: "blog-header.jpg")
            }
        },to: URLs.uploadImage, //URL Here
            method: HTTPMethod.post,
            headers: headers).response{ response in
                guard response.error == nil else{
                    print(response.error!.localizedDescription)
                    completion(response.error)
                    return
                }
                print(response)
                completion(nil)
        }
    }
    
    
    class func getUserImageAPIRouter(completion: @escaping (Result<Data,Error>) -> Void){
        request(APIRouter.getUserImage) { (response) in
            completion(response)
        }
    }
}

extension APIManager{
    // MARK:- The request function to get results in a closure
    private static func request<T: Decodable>(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<T, Error>) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
            }
            .responseJSON { response in
                print(response)
        }
    }
    
}
