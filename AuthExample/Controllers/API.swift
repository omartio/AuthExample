//
//  API.swift
//  yumee
//
//  Created by Михаил Лукьянов on 11.07.17.
//  Copyright © 2017 Михаил Лукьянов. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

protocol Requstable {
    
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: Parameters { get }
    
    var baseUrl: String { get }
}

extension Requstable {
    var baseUrl: String { return appBaseUrl }
}

let appBaseUrl = "\(serverUrl)/data/2.5/"
let serverUrl = "http://samples.openweathermap.org" // Debug

/**
 Перечисление конечных точек апи
 */
enum Endpoint {
    
    // City name
    case getWeather(String)
}

extension Endpoint: Requstable {
    
    var name: String {
        switch self {
        case .getWeather:
           return "weather"
        }
        
    }
    
    var path: String {
        return baseUrl.appending(self.name)
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        
        var params = Parameters()
        
        switch self {
        case .getWeather(let name):
            params["q"] = name
        }
        params["appid"] = API.token
        return params
    }

}

struct APIResponse {
    let success: Bool
    let data: JSON
    
    let errorString: String?
    
    init(success: Bool, data: JSON) {
        self.success = success
        self.data = data
        self.errorString = data["error"].string
    }
}

enum ServerResponse {
    case success(APIResponse)
    case failure(Error)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    var apiResponse: APIResponse? {
        switch self {
        case .success(let response):
            return response
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
    var errorString: String? {
        return apiResponse?.errorString?.htmlAttributedString()?.string ?? error?.localizedDescription
    }
}

typealias ServerResponseBlock = ((ServerResponse) -> ())

class API {
    
    static var token = "b1b15e88fa797225412429c1c50c122a1"
    
//    static func updateToken(_ token: String?) {
//
//        Defaults[.token] = token
//        self.token = token
//
//        sessionManager = createSessionManager()
//    }

    static func createSessionManager() -> SessionManager {
        var headers = SessionManager.defaultHTTPHeaders
//        if token != nil {
//            headers["Authorization"] = token!
//        }
        
        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = headers
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        return manager
    }
    
    private static var sessionManager: SessionManager = {
        return createSessionManager()
    }()

    // MARK: - Requests
    
    /**
     Отправление запроса на сервер
     
     - parameter endpoint:   "конечная точка" того что делат завпрос
     - parameter completion: ответ от сервара в формате JSON
     */
    static func request(_ endpoint: Endpoint, completion: @escaping (_ response: ServerResponse) -> Void) {
        let request = sessionManager.request(endpoint.path,
                                                method: endpoint.method,
                                                parameters: endpoint.parameters)
            .response { (response) in
                if response.error == nil {
                    let apiResponse: APIResponse
                    if let data = response.data {
                        let json = JSON(data: data)
                        apiResponse = APIResponse(success: true, data: json)
                    } else {
                        apiResponse = APIResponse(success: false, data: JSON.null)
                    }
                    completion(.success(apiResponse))
                } else {
                    print(response.error!)
                    if let data = response.data {
                        print(String(data: data, encoding: String.Encoding.utf8))
                    }
                    
                    completion(.failure(response.error!))
                }
        }
        
        debugPrint(request)
    }
    
    static func rx_request(_ endpoint: Endpoint) -> Single<APIResponse> {
        return Single<APIResponse>.create{ (single) -> Disposable in
            self.request(endpoint, completion: { (response) in
                switch response {
                case .success(let response):
                    single(.success(response))
                case .failure(let error):
                    single(.error(error))
                }
            })
            return Disposables.create()
        }
    }

}

