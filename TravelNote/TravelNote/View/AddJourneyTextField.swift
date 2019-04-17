//
//  AddJourneyTextField.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class AddJourneyTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        return false
    }

    func setUp() {

        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 5

        layer.borderWidth = 2

        layer.borderColor = UIColor.black.cgColor

        font = UIFont.appFont(size: 20)

        returnKeyType = .done

        backgroundColor = UIColor.white
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
