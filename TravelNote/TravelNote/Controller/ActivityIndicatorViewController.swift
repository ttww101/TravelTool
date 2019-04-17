//
//  ActivityIndicatorViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/30.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {

    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicatorView.startAnimating()
    }

    func setUp() {

        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        setUpIndicatorView()
    }

    func setUpIndicatorView() {

        activityIndicatorView.color = UIColor.gray

        activityIndicatorView.backgroundColor = UIColor.clear

        view.addSubview(activityIndicatorView)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        activityIndicatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true

        activityIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }
}
