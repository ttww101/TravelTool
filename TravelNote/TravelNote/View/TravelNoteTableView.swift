//
//  TravelNoteTableView.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/27.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class TravelNoteTableView: UITableView {

    init() {
        super.init(frame: CGRect.zero, style: .plain)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func delegate(delegate: TravelNoteTableViewDelegate) {

        self.delegate = delegate

        self.dataSource = delegate
    }

    private func setUp() {

        separatorStyle = .none

        backgroundColor = UIColor.white

        translatesAutoresizingMaskIntoConstraints = false
    }

    func registerClass(classes: [TravelNoteCellClass.Type]) {

        for item in classes {

            register(item.self, forCellReuseIdentifier: item.identifier)
        }
    }

    func registerNib(classes: [TravelNoteCellClass.Type]) {

        for item in classes {

            let nib = UINib(nibName: item.identifier, bundle: nil)

            register(nib, forCellReuseIdentifier: item.identifier)
        }
    }
}

protocol TravelNoteTableViewDelegate: class, UITableViewDelegate, UITableViewDataSource {

}

protocol TravelNoteCellClass: class {

    static var identifier: String { get }
}
