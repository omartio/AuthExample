//
//  AuthControllersFacrtory.swift
//  yumee
//
//  Created by Михаил Лукьянов on 05.07.17.
//  Copyright © 2017 Михаил Лукьянов. All rights reserved.
//

import Foundation

class AuthControllersFactory {
    
    func createLoginController() -> LoginViewController {
        return LoginViewController(viewModel: LoginViewModel())
    }
}
