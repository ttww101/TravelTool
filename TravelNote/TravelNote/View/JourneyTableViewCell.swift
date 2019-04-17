//
//  JourneyTableViewCell.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/4.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class JourneyTableViewCell: UITableViewCell {
    static let identifier = "JourneyTableViewCell"
    private let containerView = UIView()
    private let journeyImageView = JourneyImageView()
    private let journeyNameLabel = UILabel()
    private let journeyDateLabel = UILabel()
    private let labelContainerView = JourneyNameContainerView()
    private let gradientLayer = CAGradientLayer()
    let editButton = UIButton()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        contentView.backgroundColor = UIColor.white
        setUpContainerView()
        setUpJourneyImageView()
        setUpLabelContainerView()
        setUpJourneyNameLabel()
        setUpJourneyDateLabel()
        setUpEditButton()
    }

    private func setUpContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        contentView.leadingAnchor
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        containerView.backgroundColor = UIColor.white
//        containerView.layer.shadowOpacity = 0.7
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        containerView.layer.shadowRadius = 5
    }

    private func setUpJourneyImageView() {
        journeyImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(journeyImageView)
        journeyImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        journeyImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        journeyImageView.heightAnchor.constraint(equalTo: journeyImageView.widthAnchor, multiplier: 0.3, constant: 0).isActive = true
        journeyImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        journeyImageView.backgroundColor = UIColor.red
        journeyImageView.contentMode = .scaleAspectFill
        journeyImageView.clipsToBounds = true
    }

    private func setUpLabelContainerView() {
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelContainerView)
        labelContainerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        labelContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        labelContainerView.bottomAnchor.constraint(equalTo: journeyImageView.topAnchor).isActive = true
        labelContainerView.backgroundColor = UIColor.white
    }

    private func setUpJourneyDateLabel() {
        journeyDateLabel.translatesAutoresizingMaskIntoConstraints = false
        journeyImageView.addSubview(journeyDateLabel)
        journeyDateLabel.bottomAnchor.constraint(equalTo: journeyImageView.layoutMarginsGuide.bottomAnchor).isActive = true
        journeyDateLabel.leadingAnchor.constraint(equalTo: journeyImageView.layoutMarginsGuide.leadingAnchor).isActive = true
        journeyDateLabel.font = UIFont.appFont(size: 16)
        journeyDateLabel.textColor = UIColor.white
        journeyDateLabel.backgroundColor = UIColor.clear
    }

    private func setUpJourneyNameLabel() {
        journeyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView.addSubview(journeyNameLabel)
        journeyNameLabel.leadingAnchor.constraint(equalTo: labelContainerView.layoutMarginsGuide.leadingAnchor).isActive = true
        journeyNameLabel.bottomAnchor.constraint(equalTo: labelContainerView.layoutMarginsGuide.bottomAnchor).isActive = true
        journeyNameLabel.topAnchor.constraint(equalTo: labelContainerView.layoutMarginsGuide.topAnchor).isActive = true
        journeyNameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        journeyNameLabel.font = UIFont.appFont(size: 18)
        journeyNameLabel.textColor = UIColor.hexStringToUIColor(hex: "252A34")
    }

    private func setUpEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: labelContainerView.topAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor).isActive = true
        editButton.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor).isActive = true
        editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor).isActive = true
        journeyNameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor).isActive = true
        editButton.tintColor = UIColor.lightGray
        let image = #imageLiteral(resourceName: "pencil").withRenderingMode(.alwaysTemplate)
        editButton.setImage(image, for: .normal)
        editButton.setImage(#imageLiteral(resourceName: "pencil"), for: .highlighted)
    }

    func setJourneyName(name: String) {
        journeyNameLabel.text = name
    }

    func setJourneyDate(date: String, days: String) {
        journeyDateLabel.text = "Begin: " + date + "   Days: " + days
    }

    func setJourneyImage(index: Int) {
        let remainder = index % 4
        switch remainder {
        case 1:
            journeyImageView.image = UIImage(named: "view1")
        case 2:

            journeyImageView.image = UIImage(named: "view2")
        case 3:

            journeyImageView.image = UIImage(named: "view3")
        default:

            journeyImageView.image = UIImage(named: "view4")
        }
    }
}

class JourneyImageView: UIImageView {
    let gradientLayer = CAGradientLayer()

    init() {
        super.init(frame: CGRect.zero)

        setUpGradientLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}

class JourneyNameContainerView: UIView {
    let gradientLayer = CAGradientLayer()

    init() {
        super.init(frame: CGRect.zero)

        setUpGradientLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpGradientLayer() {
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: "EAEAEA").cgColor, UIColor.white.cgColor]

        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = self.bounds
    }
}
