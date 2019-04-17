//
//  MapViewButton.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/28.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class MapViewButton: UIButton {

    let length: CGFloat

    init(length: CGFloat) {

        self.length = length

        super.init(frame: CGRect.zero)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {

        layer.cornerRadius = length / 2

        layer.shadowOpacity = 0.7

        layer.shadowColor = UIColor.black.cgColor

        layer.shadowRadius = 5

        layer.shadowOffset = CGSize(width: 0, height: 5)

        backgroundColor = UIColor.white

        tintColor = UIColor.black
    }

    // Need pass  gray color image in
    func setButtonImage(image: UIImage) {

        let templateImage = image.withRenderingMode(.alwaysTemplate)

        setImage(templateImage, for: .normal)

        setImage(image, for: .highlighted)
    }
}
