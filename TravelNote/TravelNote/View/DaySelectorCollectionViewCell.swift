//
//  DaySelectorCollectionViewCell.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/5.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class DaySelectorCollectionViewCell: UICollectionViewCell {

    static let identifier = "DaySelectorCollectionViewCell"

    let label = DayLabel()

    private let indicateView = UIView()

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {

        setUpContainerView()

        setUpLabel()

        setUpIndicateView()
    }

    func setUpContainerView() {

        contentView.makeSubviewContraints(subViews: [containerView])

        containerView.backgroundColor = UIColor.white
    }

    private func setUpLabel() {

        containerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        let marginGuide = containerView.layoutMarginsGuide

        label.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true

        label.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true

        label.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

        label.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true

        label.backgroundColor = UIColor.white

        label.font = UIFont.appFont(size: 16)

        label.textAlignment = .center

        label.text = "Test"

        labelColor(color: UIColor.lightGray)
    }

    private func setUpIndicateView() {

        containerView.addSubview(indicateView)

        indicateView.translatesAutoresizingMaskIntoConstraints = false

        indicateView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        indicateView.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true

        indicateView.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true

        indicateView.heightAnchor.constraint(equalToConstant: 3).isActive = true

        indicateView.backgroundColor = UIColor.red

        indicateView.alpha = 0
    }

    func changeState(highlight: Bool) {

        if highlight {

            labelColor(color: UIColor.black)

            indicateView.alpha = 1

        } else {

            labelColor(color: UIColor.gray)

            indicateView.alpha = 0
        }
    }

    func labelColor(color: UIColor) {

        label.textColor = color
    }
}

class DayLabel: UILabel {

    override func drawText(in rect: CGRect) {

        let inset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

        super.drawText(in: UIEdgeInsetsInsetRect(rect, inset))
    }
}
