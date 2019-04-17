//
//  ReachabilityViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/25.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import Crashlytics

class ReachabilityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange

        setUp()
    }

    func setUp() {

        let label = UILabel()

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        label.topAnchor.constraint(equalTo: view.topAnchor, constant: -50).isActive = true

        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

        label.text = "Can't connect to internet..."

        label.numberOfLines = 0

        label.font = UIFont.appFont(size: 30)

        label.textColor = UIColor.white

        label.textAlignment = .center
    }
}
