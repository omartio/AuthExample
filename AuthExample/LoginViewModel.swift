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
    
    
    func login(_ completion: @escaping (Bool) -> Void) {
        let email = userNameObservable.value
        let password = passwordObservable.value
        
    }
}
