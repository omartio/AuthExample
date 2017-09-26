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
    var emailObservable = Variable("")
    var passwordObservable = Variable("")
    
    let emailValidObservable: Observable<Bool>
    let passwordValidObservable: Observable<Bool>
    
    var isValid = false
    let disposeBag = DisposeBag()
    
    
    init() {
        emailValidObservable = emailObservable.asObservable().map { email in
            return email.characters.count == 0 || email.isValidEmail
        }
        
        passwordValidObservable = passwordObservable.asObservable().map({ password in
            return password.characters.count == 0 || password.isValidPassword
        })
        
        Observable.combineLatest(emailValidObservable, passwordValidObservable, resultSelector: { (emailValid, passwordValid) in
            return emailValid && passwordValid
        }).subscribe(onNext: { (valid) in
            self.isValid = valid
        }).addDisposableTo(disposeBag)
    }
    
    func login(_ completion: @escaping (String?) -> Void) {
        let email = emailObservable.value
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
