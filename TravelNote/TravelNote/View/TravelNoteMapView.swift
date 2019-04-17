//
//  TravelNoteMapView.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/25.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import GoogleMaps

class TravelNoteMapView: UIView {

    weak var delegate: TravelNoteMapViewDelegate?

    private var locations: [Location]?

    private static let buttonLength: CGFloat = 60

    private let bottomDistance: CGFloat = -10

    private var mapBounds: GMSCoordinateBounds?

    let zoom: Float

    let findUserButton = MapViewButton(length: TravelNoteMapView.buttonLength)

    let viewAllIncludingUserButton = MapViewButton(length: TravelNoteMapView.buttonLength)

    let requestRouteButton = MapViewButton(length: TravelNoteMapView.buttonLength)

    private let mapView = GMSMapView()

    init(delegate: TravelNoteMapViewDelegate, locations: [Location]?, zoom: Float = 15) {

        self.delegate = delegate

        self.locations = locations

        self.zoom = zoom

        super.init(frame: CGRect.zero)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {

        setUpMapView()

        setUpFindUserButton()

        setUpviewAllIncludingUserButtonButton()

        setUpRequestRouteButton()
    }

    private func setUpMapView() {

        mapView.isMyLocationEnabled = false

        guard let locations = locations, locations.count > 0 else {

            noLocation()

            setMapViewConstraint()

            return
        }

        if locations.count == 1 {

            singleLocation()

        } else {

            mutipleLocations()
        }

        setMapViewConstraint()
    }

    private func setMapViewConstraint() {

        mapView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(mapView)

        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func noLocation() {

        //23.973875°N 120.982024°E  Taiwan
        let camera = GMSCameraPosition.camera(withLatitude: 23.973875, longitude: 120.982024, zoom: zoom)

        mapView.camera = camera
    }

    private func singleLocation() {

        guard let location = locations?.first else { return }

        createMarker(locations: [location])

        let coordinate = createCoordinateFromLocation(location: location)

        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom * 2)

        mapView.camera = camera
    }

    private func mutipleLocations() {

        guard let locations = locations else { return }

        var mapBounds = GMSCoordinateBounds(
            coordinate: createCoordinateFromLocation(location: locations[0]),
            coordinate: createCoordinateFromLocation(location: locations[1])
        )

        for i in 2 ..< locations.count {

            mapBounds = mapBounds.includingCoordinate(createCoordinateFromLocation(location: locations[i]))
        }

        self.mapBounds = mapBounds

        let update = GMSCameraUpdate.fit(mapBounds, withPadding: 50)

        mapView.animate(with: update)

        createMarker(locations: locations)
    }

    private func createCoordinateFromLocation(location: Location) -> CLLocationCoordinate2D {

        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }

    private func createMarker(locations: [Location]) {

        for location in locations {

            let coordinate = createCoordinateFromLocation(location: location)

            let marker = GMSMarker(position: coordinate)

            marker.title = location.name

            marker.map = mapView
        }
    }

    private func setUpFindUserButton() {

        addSubview(findUserButton)

        findUserButton.translatesAutoresizingMaskIntoConstraints = false

        findUserButton.heightAnchor.constraint(equalToConstant: findUserButton.length).isActive = true

        findUserButton.widthAnchor.constraint(equalToConstant: findUserButton.length).isActive = true

        findUserButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        findUserButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomDistance).isActive = true

        findUserButton.setButtonImage(image: #imageLiteral(resourceName: "cursor-gray"))

        findUserButton.addTarget(self, action: #selector(didTouchFindUserButton), for: .touchUpInside)
    }

    private func setUpviewAllIncludingUserButtonButton() {

        addSubview(viewAllIncludingUserButton)

        viewAllIncludingUserButton.translatesAutoresizingMaskIntoConstraints = false

        viewAllIncludingUserButton.heightAnchor.constraint(equalToConstant: viewAllIncludingUserButton.length).isActive = true

        viewAllIncludingUserButton.widthAnchor.constraint(equalToConstant: viewAllIncludingUserButton.length).isActive = true

        viewAllIncludingUserButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        viewAllIncludingUserButton.bottomAnchor.constraint(equalTo: findUserButton.topAnchor, constant: bottomDistance).isActive = true

        viewAllIncludingUserButton.setButtonImage(image: #imageLiteral(resourceName: "globe-view"))
    }

    private func setUpRequestRouteButton() {

        addSubview(requestRouteButton)

        requestRouteButton.translatesAutoresizingMaskIntoConstraints = false

        requestRouteButton.heightAnchor.constraint(equalToConstant: requestRouteButton.length).isActive = true

        requestRouteButton.widthAnchor.constraint(equalToConstant: requestRouteButton.length).isActive = true

        requestRouteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        requestRouteButton.bottomAnchor.constraint(equalTo: viewAllIncludingUserButton.topAnchor, constant: bottomDistance).isActive = true

        requestRouteButton.setButtonImage(image: #imageLiteral(resourceName: "route"))
    }

    func isUserLocationEnabled(bool: Bool) {

        mapView.isMyLocationEnabled = bool
    }

    func setCameraTo(camera: GMSCameraPosition) {

        mapView.animate(to: camera)
    }

    func setMapBoundsTo(bounds: GMSCoordinateBounds) {

        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80))
    }

    func addPolyline(polyline: GMSPolyline) {

        polyline.map = mapView
    }

    func clear() {

        mapView.clear()
    }

    func replaceLocations(as newLocations: [Location]) {

        self.locations = newLocations

        mapView.clear()

        setUpMapView()
    }

    @objc private func didTouchFindUserButton() {

        delegate?.findUser(completion: { [weak self] location in

            self?.setCameraToLocation(location: location)

        })
    }

    private func setCameraToLocation(location: CLLocation) {

        mapView.isMyLocationEnabled = true

        let userCamera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoom * 2)

        mapView.animate(to: userCamera)
    }
}

@objc protocol TravelNoteMapViewDelegate: class {

    func findUser(completion: @escaping (CLLocation) -> Void)

    @objc optional func didRequestRote(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (String) -> Void)
}
