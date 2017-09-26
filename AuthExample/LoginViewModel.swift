//
//  LoginViewModel.swift
//  Tapl
//
//  Created by Михаил Лукьянов on 03.06.16.
//  Copyright © 2016 Taxac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON


class LoginViewModel {
    
    // input
    var userNameObservable = Variable("")
    var passwordObservable = Variable("")
    
    
    func login(_ completion: @escaping (String?) -> Void) {
        let email = userNameObservable.value
        let password = passwordObservable.value
        
        API.request(.getWeather("London,uk")) { (serverResponse) in
            
            guard serverResponse.isSuccess else {
                completion(serverResponse.error?.localizedDescription)
                return
            }
            
            guard let json = serverResponse.apiResponse?.data else {
                completion("Нет данных")
                return
            }
            
            let tempString = String(format:"Температура %.2f К", json["main"]["temp"].floatValue)
            completion(tempString)
        }
    }
}
