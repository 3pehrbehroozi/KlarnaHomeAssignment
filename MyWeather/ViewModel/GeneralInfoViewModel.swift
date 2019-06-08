//
//  GeneralInfoViewModel.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import Foundation

class GeneralInfoViewModel {
    var title = LiveDynamicType("")
    var content = LiveDynamicType("")
    
    init(title: String, content: String) {
        self.title.set(to: title)
        self.content.set(to: content)
    }
}
