//
//  LocationTableViewCell.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/3/28.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell, TravelNoteCellClass {

    static let identifier = "LocationTableViewCell"

    @IBOutlet weak var moreImageView: UIImageView!

    @IBOutlet weak var locationNameLabel: UILabel!

    @IBOutlet weak var travelTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        configMoreImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configMoreImage() {

        let image = #imageLiteral(resourceName: "down-arrow").withRenderingMode(.alwaysTemplate)

        moreImageView.image = image

        moreImageView.tintColor = UIColor.hexStringToUIColor(hex: "#2980B9")
    }
}
