//
//  GoogleDirectionManager.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/26.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit
import GoogleMaps

class GoogleDirectionManager {

    func fetchRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {

        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?" +
                           "origin=\(origin.latitude),\(origin.longitude)" +
                           "&destination=\(destination.latitude),\(destination.longitude)" +
                           "&key=AIzaSyCpfxEzeDUk6i96FuU8yWPOcGxMlSvpsTc"

        Alamofire.request(directionURL).validate(statusCode: 200 ..< 300).responseJSON(completionHandler: { response in

            switch response.result {

            case .success(let value):

                let json = JSON(value)

                let overViewPolyline = json["routes"][0]["overview_polyline"]["points"].stringValue

                completion(overViewPolyline)

            case .failure(let error):

                print("=================")
                print(error)
            }
        })
    }
}
