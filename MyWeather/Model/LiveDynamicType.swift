//
//  File.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import Foundation

class LiveDynamicType<T> {
    typealias LiveDynamicTypeListener = (T) -> Void
    
    var listener: LiveDynamicTypeListener?
    var value: T {
        didSet {
            self.listener?(self.value)
        }
    }
    
    func bind(_ listener: @escaping LiveDynamicTypeListener) {
        self.listener = listener
        self.listener?(self.value)
    }
    
    func set(to value: T) {
        self.value = value
    }
    
    init(_ value: T) {
        self.value = value
    }
}
