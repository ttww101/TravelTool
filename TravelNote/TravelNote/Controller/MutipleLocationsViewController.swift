//
//  MutipleLocationsViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/28.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import MapKit

class MutipleLocationsViewController: UIViewController, TravelNoteMapViewDelegate, CLLocationManagerDelegate {

    lazy var travelNoteMapView: TravelNoteMapView = TravelNoteMapView(delegate: self, locations: self.locations, zoom: self.zoom)

    lazy var locationManager: CLLocationManager = UserLocationManager().createLocationManagerWith(accuracy: kCLLocationAccuracyBestForNavigation, filter: 50, delegate: self)

    var locations: [Location]?

    var getLocationCompletionHandlier: ((CLLocation) -> Void )?

    let zoom: Float

    init(locations: [Location]?, zoom: Float) {

        self.locations = locations

        self.zoom = zoom

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    func setUp() {

        travelNoteMapView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(travelNoteMapView)

        travelNoteMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        travelNoteMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        travelNoteMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        travelNoteMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    // MARK: TravelNoteMapViewDelegate

    func findUser(completion: @escaping (CLLocation) -> Void) {

        locationManager.stopUpdatingLocation()

        locationManager.startUpdatingLocation()

        getLocationCompletionHandlier = completion
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        getLocationCompletionHandlier?(locations.last!)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        UserLocationManager().authorizationStatusHandler(status: status, completion: { [unowned self] in

            self.showUserAccessStatusErrorAlert()
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        locationManager.stopUpdatingLocation()

        print(error)
    }

    func showUserAccessStatusErrorAlert() {

        let alertController = UIAlertController(title: "User location access error.", message: "Please check the status of internet connect or allow the app accesses your location.", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [unowned self] _ in

            self.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }

    func isHidden(bool: Bool) {

        travelNoteMapView.requestRouteButton.isHidden = bool

        travelNoteMapView.viewAllIncludingUserButton.isHidden = bool

        travelNoteMapView.findUserButton.isHidden = bool
    }
}
