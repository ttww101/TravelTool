//
//  JourneyNavigationView.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/4.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class JourneyNavigationView: UIView {

    let addButton = UIButton()

    let backButton = UIButton()

    let label = UILabel()

    init() {
        super.init(frame: CGRect.zero)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        setUpImageView()
        setUpLabel()
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
    }

    func setUpImageView() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        addButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        addButton.backgroundColor = UIColor.white

        let image = #imageLiteral(resourceName: "plus-symbol").withRenderingMode(.alwaysTemplate)
        addButton.setImage(#imageLiteral(resourceName: "plus-symbol"), for: .highlighted)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = UIColor.lightGray
    }

    func setUpLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.text = "旅行助手直通车"
        label.font = UIFont.appFont(size: 20)
        label.textColor = UIColor.hexStringToUIColor(hex: "252A34")
    }

    func setUpBackButton() {
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true

        let image = #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "arrow"), for: .highlighted)
        backButton.tintColor = UIColor.lightGray
        addButton.isHidden = true
    }

    func noService() {
        guard let text = label.text else { return }
        label.text = text + " (No service)"
    }
}
