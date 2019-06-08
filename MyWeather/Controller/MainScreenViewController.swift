//
//  MainPageViewController.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var locationPermissionView: UserLocationPermissionView?
    private var viewModel: MainScreenViewModel?
    private var refreshControl: UIRefreshControl!
    private var headerCell: WeatherHeaderTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocationPermissionView()
        self.setupTableView()
        self.setupRefreshControl()
        
        self.viewModel = MainScreenViewModel(delegate: self)
        
        self.viewModel?.locationManagerPermissionStatus.bind {[weak self] status in
            self?.locationPermissionView?.isHidden = status == .allowed
            self?.locationPermissionView?.set(loading: status == .requesting)
            self?.locationPermissionView?.set(message: status.message, actionTitle: status.actionTitle)
        }
        self.viewModel?.generalInfo.bind {[weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - private methods
extension MainScreenViewController {
    @objc private func refreshControlDidRefresh() {
        self.refreshControl.endRefreshing()
        self.viewModel?.reload()
    }
    
    private func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    private func setupLocationPermissionView() {
        self.locationPermissionView = UserLocationPermissionView()
        self.locationPermissionView?.delegate = self
        self.locationPermissionView?.translatesAutoresizingMaskIntoConstraints = false
        if let permissionView = self.locationPermissionView {
            self.view.addSubview(permissionView)
            NSLayoutConstraint.activate([
                permissionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                permissionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            ])
            if #available(iOS 11.0, *) {
                NSLayoutConstraint.activate([
                    permissionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                    permissionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    permissionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    permissionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ])
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
            self.tableView.contentInset.bottom = UIDevice.current.safeLayoutBottomInset
        }
        self.tableView.register(WeatherHeaderTableViewCell.nib, forCellReuseIdentifier: WeatherHeaderTableViewCell.nibName)
        self.tableView.register(GeneralInfoTableViewCell.nib, forCellReuseIdentifier: GeneralInfoTableViewCell.nibName)
    }
}

// MARK: - UserLocationPermissionViewDelegate
extension MainScreenViewController: UserLocationPermissionViewDelegate {
    func userLocationPermissionViewActionButtonPressed() {
        self.viewModel?.locationPermissionViewActionPressed()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel?.weatherHeaderViewModel == nil ? 0 : 1
        } else {
            return self.viewModel?.generalInfo.value.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.headerCell != nil {
                return self.headerCell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHeaderTableViewCell.nibName) as! WeatherHeaderTableViewCell
                cell.viewModel = self.viewModel?.weatherHeaderViewModel
                self.headerCell = cell
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoTableViewCell.nibName) as! GeneralInfoTableViewCell
            cell.viewModel = self.viewModel?.generalInfo.value[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.viewModel?.headerCellDidSelected()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.viewModel?.setTableViewScroll(yOffset: scrollView.contentOffset.y)
    }
}

// MARK: - MainScreenViewModelDelegate
extension MainScreenViewController: MainScreenViewModelDelegate {
    func mainScreenViewModelTableViewShouldBeReloaded() {
        self.tableView.reloadData()
    }
}
