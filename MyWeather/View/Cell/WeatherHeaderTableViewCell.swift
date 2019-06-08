//
//  WeatherHeaderTableViewCell.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

class WeatherHeaderTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeZoneNameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var timezoneLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var viewModel: WeatherHeaderViewModel? {
        didSet {
            self.viewModel?.isLoading.bind {[weak self] isLoading in
                isLoading ? self?.loadingActivityIndicator.startAnimating() : self?.loadingActivityIndicator.stopAnimating()
                self?.timezoneLabel.isHidden = isLoading
                self?.timeLabel.isHidden = isLoading
                self?.summaryLabel.isHidden = isLoading
            }
            self.viewModel?.weatherSummary.bind {[weak self] summary in
                self?.summaryLabel.text = summary
            }
            self.viewModel?.timeZoneName.bind {[weak self] name in
                self?.timezoneLabel.text = name
            }
            self.viewModel?.time.bind {[weak self] time in
                if let time = time {
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar.current
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    self?.timeLabel.text = formatter.string(from: time)
                } else {
                    self?.timeLabel.text = "Time: Unknown"
                }
            }
            self.viewModel?.containerTopConstraint.bind {[weak self] constant in
                self?.containerTopConstraint.constant = constant
            }
            self.viewModel?.timeZoneTopConstraint.bind {[weak self] constant in
                self?.timeZoneNameLabelTopConstraint.constant = constant
            }
            self.viewModel?.containerHeightConstraint.bind {[weak self] constant in
                self?.containerHeightConstraint.constant = constant
            }
            self.viewModel?.backgroundColor.bind {[weak self] color in
                self?.containerView.backgroundColor = color
            }
            self.viewModel?.errorString.bind {[weak self] error in
                self?.timezoneLabel.isHidden = error != nil
                self?.timeLabel.isHidden = error != nil
                if let error = error {
                    self?.summaryLabel.text = "\(error)\nTap to retry"
                }
            }
        }
    }
}
