//
//  GeneralInfoTableViewCell.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    
    var viewModel: GeneralInfoViewModel? {
        didSet {
            self.viewModel?.title.bind {[weak self] title in
                self?.titleLabel.text = title
            }
            self.viewModel?.content.bind {[weak self] title in
                self?.contentLabel.text = title
            }
        }
    }
}
