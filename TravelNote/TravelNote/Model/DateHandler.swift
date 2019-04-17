//
//  DateHandler.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import Foundation

class DateHandler {

    private let dateFormatter = DateFormatter.appDateFormatter()

    private lazy var time: Double = {

        return self.trasferStringToTimeIntervalSince1970(dateString: "2010/12/31")

    }()

    init() { }

    func transferTimeIntervalToString(timeInterval: TimeInterval) -> String {

        if timeInterval < time {

            return ""
        }

        let date = Date(timeIntervalSince1970: timeInterval)

        let dateString = dateFormatter.string(from: date)

        return dateString
    }

    func trasferStringToTimeIntervalSince1970(dateString: String) -> Double {

        guard let date = dateFormatter.date(from: dateString)?.timeIntervalSince1970 else { return -1 }

        return date
    }

    func calculateDays(start: String, end: String) -> Int {

        guard let firstDate = dateFormatter.date(from: start) else { return -1 }

        guard let lastDate = dateFormatter.date(from: end) else { return -1 }

        let currentCalendar = Calendar.current

        let units: Set<Calendar.Component> = [.day]

        let daysBetween = currentCalendar.dateComponents(units, from: firstDate, to: lastDate)

        return daysBetween.day ?? -1
    }

    func transferTimeIntervalSince1970ToDate(timeInterval: Double) -> Date {

        if timeInterval < time {

            return Date()
        }

        return Date(timeIntervalSince1970: timeInterval)
    }

    func getDateFromString(_ text: String) -> Date? {

        guard let date = dateFormatter.date(from: text) else { return nil }

        return date
    }

    func minimumDate() -> Date {

        return Date(timeIntervalSince1970: time)
    }

    func checkData(name: String, startDay: String, endDay: String) -> ErrorEnum? {

        if name == "" {

            return ErrorEnum.journeyNameEmptyError

        } else if startDay == "" {

            return ErrorEnum.startDayEmptyError

        } else if endDay == "" {

            return ErrorEnum.endDayEmptyError
        }

        let startDate = trasferStringToTimeIntervalSince1970(dateString: startDay)

        let endDate = trasferStringToTimeIntervalSince1970(dateString: endDay)

        if startDate > endDate {

            return ErrorEnum.dateTimeError
        }

        return nil
    }
}

extension DateFormatter {

    static func appDateFormatter() -> DateFormatter {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }
}
