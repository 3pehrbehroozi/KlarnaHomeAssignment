//
//  WeatherHeaderViewModel.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

class WeatherHeaderViewModel {
    var isLoading = LiveDynamicType(false)
    var timeZoneName = LiveDynamicType("")
    var weatherSummary = LiveDynamicType("")
    var time = LiveDynamicType<Date?>(nil)
    var containerHeightConstraint = LiveDynamicType<CGFloat>(0)
    var containerTopConstraint = LiveDynamicType<CGFloat>(0)
    var timeZoneTopConstraint = LiveDynamicType<CGFloat>(0)
    var backgroundColor = LiveDynamicType<UIColor>(.white)
    var errorString = LiveDynamicType<String?>(nil)
    
    fileprivate class var defaultContainerHeight: CGFloat {
        var topInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            topInset = UIDevice.current.safeLayoutTopInset
        }
        return CGFloat(250) + topInset
    }
    
    init() {
        self.timeZoneTopConstraint.set(to: UIDevice.current.hasNotch ? 32 + UIDevice.current.safeLayoutTopInset : 32 )
        self.containerHeightConstraint.set(to: WeatherHeaderViewModel.defaultContainerHeight)
    }
}

// MARK: - public methods
extension WeatherHeaderViewModel {
    func set(scrollOffset offset: CGFloat) {
        guard offset <= 0 else {
            self.containerTopConstraint.set(to: 0)
            self.containerHeightConstraint.set(to: WeatherHeaderViewModel.defaultContainerHeight)
            return
        }
        self.containerTopConstraint.set(to: offset)
        self.containerHeightConstraint.set(to: WeatherHeaderViewModel.defaultContainerHeight + abs(offset))
    }
}
