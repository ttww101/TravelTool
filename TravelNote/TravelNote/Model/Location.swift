//
//  Location.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/3/29.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import MapKit
import GooglePlaces
import Firebase

struct Location: CellType {

    let name: String

    var website: URL?

    var day: Int = 0

    let type: CellCase

    let latitude: Double

    let longitude: Double

    var sequency: Int = 0

    var parentKey: String = ""

    var key: String

    var travelTime = -1

    init(name: String, latitude: Double, longitude: Double, website: String, day: Int, sequency: Int, parentKey: String, key: String, type: CellCase = .normal) {

        self.name = name

        self.latitude = latitude

        self.longitude = longitude

        self.website = URL(string: website)

        self.day = day

        self.sequency = sequency

        self.type = type

        self.parentKey = parentKey

        self.key = key
    }

    static func createLocationObject(with dict: [String: Any], parentKey: String, key: String) -> Location? {

        guard let name = dict["name"] as? String else { return nil }

        guard let latitude = dict["latitude"] as? Double else { return nil }

        guard let longitude = dict["longitude"] as? Double else { return nil }

        guard let day = dict["day"] as? Int else { return nil }

        guard let sequency = dict["sequency"] as? Int else { return nil }

        guard let website = dict["webSite"] as? String else { return nil }

        return Location(name: name, latitude: latitude, longitude: longitude, website: website, day: day, sequency: sequency, parentKey: parentKey, key: key)
    }
}

struct SearchCell: CellType {

    let type: CellCase = .search

}

protocol CellType {

    var type: CellCase { get }

}
