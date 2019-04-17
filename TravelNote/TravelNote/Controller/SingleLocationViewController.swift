//
//  SingleLocationViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/25.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

class SingleLocationViewController: UIViewController, TravelNoteMapViewDelegate {

    let location: Location

    let userLocationManager = UserLocationManager()

    lazy var locationManager: CLLocationManager = self.userLocationManager.createLocationManagerWith(accuracy: kCLLocationAccuracyBestForNavigation, filter: 50, delegate: self)

    lazy var mapView: SingleLocationMapView = SingleLocationMapView(delegate: self, location: self.location)

    var getLocationCompletionHandler: ((CLLocation) -> Void)?

    init(location: Location) {

        self.location = location

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    private func setUp() {

        view.backgroundColor = UIColor.white

        setUpMapView()

        setUpNavigationView()
    }

    func pushBackToParentController() {

        navigationController?.popViewController(animated: true)
    }

    private func setUpMapView() {

        mapView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mapView)

        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        mapView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }

    func setUpNavigationView() {

        let navigationView = JourneyNavigationView()

        view.addSubview(navigationView)

        navigationView.translatesAutoresizingMaskIntoConstraints = false

        navigationView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        navigationView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true

        navigationView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

        navigationView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        navigationView.setUpBackButton()

        navigationView.label.text = location.name

        navigationView.backButton.addTarget(self, action: #selector(pushBackToParentController), for: .touchUpInside)
    }

    func findUser(completion: @escaping (CLLocation) -> Void) {

        checkAuthorization()

        getLocationCompletionHandler = completion

        locationManager.stopUpdatingLocation()

        locationManager.startUpdatingLocation()
    }

    func didRequestRote(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {

        checkAuthorization()

        let directionManager = GoogleDirectionManager()

        directionManager.fetchRoute(origin: origin, destination: destination, completion: completion)
    }

    func checkAuthorization() {

        userLocationManager.authorizationStatusHandler(status: CLLocationManager.authorizationStatus(), completion: {

            showUserAccessStatusErrorAlert()

            return
        })
    }

    func showUserAccessStatusErrorAlert() {

        let alertController = UIAlertController(title: "User location access error.", message: "Please check the status of internet connect or allow the app accesses your location.", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [unowned self] _ in

            self.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension SingleLocationViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        getLocationCompletionHandler?(locations.last!)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        userLocationManager.authorizationStatusHandler(status: status, completion: { [weak self] in

            self?.showUserAccessStatusErrorAlert()
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        locationManager.stopUpdatingLocation()

        print(error)
    }
}
