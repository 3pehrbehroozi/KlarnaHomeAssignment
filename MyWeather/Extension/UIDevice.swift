//
//  UIDevice.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

public extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return self.safeLayoutBottomInset > 0
        } else {
            return false
        }
    }
    
    var safeLayoutTopInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
        return 0
    }
    
    var safeLayoutBottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}
