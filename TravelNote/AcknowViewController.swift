//
//  AcknowViewController.swift
//  Spending
//
//  Created by master on 2018/1/27.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit
import SnapKit

class AcknowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Acknowledgements"
        
        let textView = UITextView()
        view.addSubview(textView)
        let path = Bundle.main.path(forResource: "Pods-TravelNote-acknowledgements", ofType: "markdown")
        textView.text = try! String(contentsOfFile: path!)
        textView.isEditable = false
        textView.isSelectable = false
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.left.right.equalTo(view)
        }
    }
}
