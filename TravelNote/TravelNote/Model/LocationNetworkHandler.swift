//
//  LocationNetworkHandler.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/27.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import SwiftyJSON

class LocationNetworkHandler {

    private let ref = TravelNoteNetworkHandler.shared.ref

    private let locationsNode = StringEnum.locations.rawValue

    private let key: String

    private let totalDays: Int

    weak var delegate: LocationNetworkHandlerDelegate?

    init(totalDays: Int, key: String, delegate: LocationNetworkHandlerDelegate) {

        self.totalDays = totalDays

        self.key = key

        self.delegate = delegate

        ref.child(locationsNode).keepSynced(true)
    }

    func networkUploadLocationWith(location: Location) {

        ref.child(locationsNode).child(location.parentKey).child(location.key).updateChildValues(

            [
                "name": location.name,
                "latitude": location.latitude,
                "longitude": location.longitude,
                "webSite": location.website?.absoluteString ?? "",
                "day": location.day,
                "sequency": location.sequency,
                "parentKey": location.parentKey
            ])

        delegate?.didUploadLocationWith(location: location)
    }

    func loadLocationFromNetwork() {

        ref.child(locationsNode).child(key).queryOrdered(byChild: "day").queryStarting(atValue: 0).observeSingleEvent(of: .value, with: { [weak self] snapshot in

            guard let holdSelf = self else { return }

            var tempLocations: [Location] = []

            for child in snapshot.children {

                guard let snap = child as? FIRDataSnapshot else { return }

                guard let dict = snap.value as? [String: Any] else { return }

                guard let location = Location.createLocationObject(with: dict, parentKey: holdSelf.key, key: snap.key) else { return }

                tempLocations.append(location)
            }

            var totalLocations: [[CellType]] = []

            for i in 0...holdSelf.totalDays {

                var locations = tempLocations.filter { location in

                    return location.day == i
                }

                locations = locations.sorted(by: { (location1, location2) in

                    return location1.sequency < location2.sequency
                })

                totalLocations.append(locations)

                totalLocations[i].append(SearchCell())
            }

            holdSelf.delegate?.didGetLocationsFromNetwork(totalLocations: totalLocations)
        })
    }

    func updateLocationSequency(locations: [CellType]) {

        for i in 0 ..< locations.count {

            guard let location = locations[i] as? Location else { continue }

            ref.child(locationsNode).child(location.parentKey).child(location.key).updateChildValues(
                [ "sequency": i]
            )
        }
    }

    func networkDeleteLocation(with location: Location) {

        ref.child(locationsNode).child(location.parentKey).child(location.key).removeValue()
    }

    // MARK: Calculate travel time Control With indexPath

    func calculateTravelTime(locations: [CellType]) {

        if locations.count < 2 {

            return
        }

        for i in 0 ..< (locations.count - 1) {

            getTravelTime(from: locations[i], to: locations[i + 1])
        }
    }

    func getTravelTime(from origin: CellType, to destination: CellType) {

        guard var originLocation = origin as? Location else { return }

        guard let destination = destination as? Location else {

            originLocation.travelTime = -1

            delegate?.didFinishCalculateTravelTime(location: originLocation)

            return
        }

        let originString = "origin=\(originLocation.latitude),\(originLocation.longitude)"

        let destinationString = "&destination=\(destination.latitude),\(destination.longitude)"

        let key = "&key=AIzaSyCpfxEzeDUk6i96FuU8yWPOcGxMlSvpsTc"

        let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"

        let urlString = baseURL + originString + destinationString + key

        Alamofire.request(urlString).validate(statusCode: 200 ..< 300).responseJSON(completionHandler: { [weak self] response in

            switch response.result {

            case .success:

                if let jsonObject = response.result.value {

                    let json = JSON(jsonObject)

                    var totalTime = 0

                    for step in json["routes"][0]["legs"][0]["steps"] {

                        let time = step.1["duration"]["value"].intValue

                        totalTime += time
                    }

                    originLocation.travelTime = totalTime

                    self?.delegate?.didFinishCalculateTravelTime(location: originLocation)
                }

            case .failure(let error):

                print(error)

                return
            }
        })
    }
}

protocol LocationNetworkHandlerDelegate: class {

    func didGetLocationsFromNetwork(totalLocations: [[CellType]])

    func didUploadLocationWith(location: Location)

    func didFinishCalculateTravelTime(location: Location)
}
