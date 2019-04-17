//
//  CellCase.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/3/29.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//
import UIKit

enum CellCase: String {

    case normal

    case search

    func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {

        switch self {

        case .normal:

            let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath)

            return cell

        case .search:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return nil }

            cell.selectionStyle = .none

            return cell
        }
    }
}
