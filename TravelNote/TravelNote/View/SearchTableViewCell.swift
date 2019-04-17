//
//  SearchTableViewCell.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/3/29.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell, TravelNoteCellClass {

    static let identifier = "SearchTableViewCell"

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var addImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setButton()

        setAddImageView()
    }

    func setButton() {
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderColor = UIColor.hexStringToUIColor(hex: "#A44A4A").cgColor
        searchButton.layer.borderWidth = 2
        searchButton.titleLabel?.textAlignment = .center
        searchButton.setTitleColor(UIColor.black, for: .normal)
        searchButton.setTitle("搜寻景点", for: .normal)
    }

    func setAddImageView() {
        let image = #imageLiteral(resourceName: "plus")
        let templateImage = image.withRenderingMode(.alwaysTemplate)
        addImageView.image = templateImage
        addImageView.tintColor = UIColor.hexStringToUIColor(hex: "#A44A4A")
    }
}
