//
//  UserLocationPermissionView.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

protocol UserLocationPermissionViewDelegate: class {
    func userLocationPermissionViewActionButtonPressed()
}

class UserLocationPermissionView: UIView {
    private var actionButton: UIButton!
    private var locationStatusLabel: UILabel!
    private var loadingActivityIndicator: UIActivityIndicatorView!
    
    weak var delegate: UserLocationPermissionViewDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.actionButton == nil {
            self.setupView()
        }
    }
}

// MARK: - public methods
extension UserLocationPermissionView {
    func set(loading isLoading: Bool) {
        isLoading ? self.loadingActivityIndicator.startAnimating() : self.loadingActivityIndicator.stopAnimating()
        self.actionButton.isHidden = isLoading
        self.locationStatusLabel.isHidden = isLoading
    }
    
    func set(message: String, actionTitle: String) {
        self.locationStatusLabel.text = message
        self.actionButton.setTitle(actionTitle, for: .normal)
    }
}

// MARK: - private methods
extension UserLocationPermissionView {
    private func setupView() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        
        self.actionButton = UIButton()
        self.actionButton.translatesAutoresizingMaskIntoConstraints = false
        self.actionButton.addTarget(self, action: #selector(actionButtonTouchUpInside), for: .touchUpInside)
        self.actionButton.setTitleColor(.blue, for: .normal)
        self.addSubview(self.actionButton)
        
        self.locationStatusLabel = UILabel()
        self.locationStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.locationStatusLabel.textColor = .black
        self.locationStatusLabel.numberOfLines = 0
        self.locationStatusLabel.textAlignment = .center
        self.addSubview(self.locationStatusLabel)
        
        self.loadingActivityIndicator = UIActivityIndicatorView()
        self.loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.loadingActivityIndicator.style = .gray
        self.loadingActivityIndicator.hidesWhenStopped = true
        self.addSubview(self.loadingActivityIndicator)
        
        
        NSLayoutConstraint.activate([
            self.actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.actionButton.heightAnchor.constraint(equalToConstant: 40),
            self.actionButton.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 4),
            
            self.locationStatusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.locationStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.locationStatusLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -4),
            
            self.loadingActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.loadingActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ])
    }
    
    @objc private func actionButtonTouchUpInside() {
        self.delegate?.userLocationPermissionViewActionButtonPressed()
    }
}
