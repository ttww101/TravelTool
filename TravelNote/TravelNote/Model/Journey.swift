//
//  File.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/18.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

struct Journey {

    var name: String

    var startDay: Double

    var endDay: Double

    var days: Int

    let key: String

    static func getJourneyWith(dictionary: [String: Any], key: String) -> Journey? {

        guard let name = dictionary["name"] as? String else { return nil }

        guard let startDay = dictionary["startDay"] as? Double else { return nil }

        guard let endDay = dictionary["endDay"] as? Double else { return nil }

        guard let days = dictionary["days"] as? Int else { return nil }

        return Journey(name: name, startDay: startDay, endDay: endDay, days: days, key: key)
    }
}
