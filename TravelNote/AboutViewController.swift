//
//  AboutViewController.swift
//  Spending
//
//  Created by master on 2018/1/14.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit
import SnapKit
//import Closures

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        title = "關於"
        
        let iconImage = #imageLiteral(resourceName: "icon")
        let iconImageView = UIImageView(image: iconImage)
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(60)
        }
        
        let appNameLabel = UILabel()
        view.addSubview(appNameLabel)
        appNameLabel.text = "旅行直通车"
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        appNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        
        let appVersionLabel = UILabel()
        view.addSubview(appVersionLabel)
        appVersionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        appVersionLabel.font = UIFont.systemFont(ofSize: 12)
        appVersionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
        }
        
        let licenseBtn = UIButton()
        view.addSubview(licenseBtn)
        licenseBtn.setTitle("Acknowledgements", for: .normal)
        
//        licenseBtn.onTap {
//            self.navigationController?.pushViewController(AcknowViewController(), animated: true)
//        }
        licenseBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(appVersionLabel.snp.bottom).offset(40)
        }
    }
}
