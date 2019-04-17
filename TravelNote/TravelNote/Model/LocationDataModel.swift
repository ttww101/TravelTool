//
//  LocationDataModel.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/20.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//
import Foundation

class LocationDataModel: LocationNetworkHandlerDelegate {

    weak var delegate: LocationDataModelDelegate?

    private let journey: Journey

    private let key: String

    private lazy var networkHandler: LocationNetworkHandler = LocationNetworkHandler(totalDays: self.journey.days, key: self.key, delegate: self)

    private var totalLocations: [[CellType]]

    init(journey: Journey) {

        self.journey = journey

        self.key = journey.key

        self.totalLocations = []

        for _ in 0...journey.days {

            totalLocations.append([SearchCell()])
        }
    }

    // MARK: Manipulate Location
    func loadLocationsFromFirebase() {

        networkHandler.loadLocationFromNetwork()
    }

    func loadTravelTimeWith(specificDay: Int) {

        networkHandler.calculateTravelTime(locations: totalLocations[specificDay])
    }

    func createLocation(name: String, latitude: Double, longitude: Double, website: String, specificDay: Int) {

        let location = Location(
            name: name,
            latitude: latitude,
            longitude: longitude,
            website: website,
            day: specificDay,
            sequency: totalLocations[specificDay].count - 1,
            parentKey: key,
            key: UUID().uuidString
        )

        networkHandler.networkUploadLocationWith(location: location)
    }

    func deleteLocation(row: Int, specificDay: Int, completion: () -> Void) {

        guard let location = totalLocations[specificDay].remove(at: row) as? Location else { return }

        networkHandler.networkDeleteLocation(with: location)

        updateLocationSequence(specificDay: specificDay)

        networkHandler.updateLocationSequency(locations: totalLocations[specificDay])

        completion()

        if location.sequency > 0 {

            networkHandler.getTravelTime(
                from: totalLocations[specificDay][location.sequency - 1],
                to: totalLocations[specificDay][location.sequency])
        }
    }

    func updateLocationSequence(specificDay: Int) {

        for i in 0 ..< totalLocations[specificDay].count {

            guard var location = totalLocations[specificDay][i] as? Location else { continue }

            location.sequency = i

            totalLocations[specificDay][i] = location
        }
    }

    // MARK: Deliver data
    func getLocationWith(day: Int, row: Int) -> CellType {

        return totalLocations[day][row]
    }

    func numberOfLocationIn(specificDay: Int) -> Int {

        if specificDay < 0 || specificDay >= totalLocations.count {

            return 0

        } else {

            return totalLocations[specificDay].count
        }
    }

    func getJourneyName() -> String {

        return journey.name
    }

    func getDays() -> Int {

        return journey.days
    }

    func getLocations(specificDay: Int) -> [Location] {

        var locations: [Location] = []

        for item in totalLocations[specificDay] {

            guard let item = item as? Location else { continue }

            locations.append(item)
        }

        return locations
    }

    // MARK: LocationComunication protocol
    func didGetLocationsFromNetwork(totalLocations: [[CellType]]) {

        self.totalLocations = totalLocations

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didSetLocationsInDataModel()
        }
    }

    func didUploadLocationWith(location: Location) {

        totalLocations[location.day].insert(location, at: location.sequency)

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didAddNewLocationInDataModel(sequency: location.sequency)
        }

        if location.sequency < 1 {

            return
        }

        DispatchQueue.global().async {[weak self] in

            guard let holdSelf = self else { return }

            holdSelf.networkHandler.getTravelTime(
                from: holdSelf.totalLocations[location.day][location.sequency - 1],
                to: holdSelf.totalLocations[location.day][location.sequency]
            )
        }
    }

    func didFinishCalculateTravelTime(location: Location) {

        totalLocations[location.day][location.sequency] = location

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didCalculatedTravelTimeWith(location: location)
        }
    }
}

protocol LocationDataModelDelegate: class {

    func didSetLocationsInDataModel()

    func didAddNewLocationInDataModel(sequency: Int)

    func didCalculatedTravelTimeWith(location: Location)
}
