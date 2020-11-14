//
//  APIRouter.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/8/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible{
    
    // The endpoint name
    case register(_ email: String, _ password: String, _ name: String, _ age: Int)
    case login(_ email: String, _ password: String)
    case getUserTasks
    case addTask(_ description: String)
    case deleteTask
    case getUserData
    case logout
    case updateUserData(_ age: Int)
    case getUserImage
    case uploadUserImage(imageData: Data)
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self{
        case .getUserTasks, .getUserData, .getUserImage:
            return .get
        case .deleteTask:
            return .delete
        case .updateUserData:
            return .put
        default:
            return .post // .addTask , .logout ,.uploadUserImage, .register, .uploadUserImage
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [ParameterKeys.email: email, ParameterKeys.password: password]
        case .addTask(let description):
            return [ParameterKeys.description: description]
        case .updateUserData(let age):
            return [ParameterKeys.age: age]
        case .register(let email, let password, let name, let age):
            return [ParameterKeys.email: email, ParameterKeys.password: password,ParameterKeys.name: name,ParameterKeys.age: age]
        default:
            return nil
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return URLs.login
        case .getUserTasks, .addTask:
            return URLs.task
        case .deleteTask:
            return URLs.task + "/\(UserDefaultsManager.shared().taskId ?? "")"
        case .getUserData:
            return URLs.userData
        case .logout:
            return URLs.logOut
        case .updateUserData:
            return URLs.userData
        case .getUserImage:
            return  "/user/\(UserDefaultsManager.shared().userId ?? "")/avatar"
        case .register:
            return URLs.register
        case .uploadUserImage:
            return URLs.uploadImageRouter
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try URLs.base.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //httpMethod
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .getUserTasks, .addTask ,.updateUserData, .deleteTask:
            urlRequest.setValue("Bearer \(UserDefaultsManager.shared().token ?? "")",
                forHTTPHeaderField: HeaderKeys.Authorization)
            urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
        case .getUserData, .logout, .uploadUserImage:
            urlRequest.setValue("Bearer \(UserDefaultsManager.shared().token ?? "")",
                forHTTPHeaderField: HeaderKeys.Authorization)
        case .register:
            urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
        default:
            break
        }
        //urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
        
        // HTTP Body
        let httpBody: Data? = {
            switch self {
            default:
                return nil
            }
        }()
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get, .delete:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        print(try encoding.encode(urlRequest, with: parameters))
        return try encoding.encode(urlRequest, with: parameters)
        
        
    }
    
    
}

extension APIRouter {
    private func encodeToJSON<T: Encodable>(_ body: T) -> Data? {
        do {
            let anyEncodable = AnyEncodable(body)
            let jsonData = try JSONEncoder().encode(anyEncodable)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
}

// type-erasing wrapper
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
