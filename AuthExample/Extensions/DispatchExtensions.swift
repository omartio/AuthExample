//
//  DispatchExtensions.swift
//  yumee
//
//  Created by Михаил Лукьянов on 05.07.17.
//  Copyright © 2017 Михаил Лукьянов. All rights reserved.
//

import Foundation

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
