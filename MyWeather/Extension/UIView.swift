//
//  UIView.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

extension UIView {
    class var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
    
    class var nibName: String {
        return String(describing: self)
    }
}
