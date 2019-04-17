//
//  SingleLocationMapView.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/25.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import GoogleMaps

class SingleLocationMapView: UIView {

    weak var delegate: TravelNoteMapViewDelegate?

    private let location: Location

    private var previousPolyline: GMSPolyline?

    let zoom: Float

    private let travelNoteMapView: TravelNoteMapView

    init(delegate: TravelNoteMapViewDelegate, location: Location, zoom: Float = 7) {

        self.delegate = delegate

        self.location = location

        self.zoom = zoom

        self.travelNoteMapView = TravelNoteMapView(delegate: delegate, locations: [location], zoom: zoom)

        super.init(frame: CGRect.zero)

        setUp()
    }

    deinit {

        travelNoteMapView.clear()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {

        setUpMapView()

        setUpButton()
    }

    private func setUpMapView() {

        travelNoteMapView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(travelNoteMapView)

        travelNoteMapView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        travelNoteMapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        travelNoteMapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        travelNoteMapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setUpButton() {

        travelNoteMapView.viewAllIncludingUserButton.addTarget(self, action: #selector(didTouchViewAllButton), for: .touchUpInside)

        travelNoteMapView.requestRouteButton.addTarget(self, action: #selector(didTouchRouteRequestButton), for: .touchUpInside)

    }

    @objc private func didTouchViewAllButton() {

        deletePreviousPolyline()

        delegate?.findUser(completion: { [weak self] location in

            self?.setCameraIncludingUserLocationAndDestination(userLocation: location)
        })
    }

    @objc private func didTouchRouteRequestButton() {

        delegate?.findUser(completion: { [weak self] userLocation in

            guard let holdSelf = self else { return }

            holdSelf.delegate?.didRequestRote?(origin: userLocation.coordinate, destination: holdSelf.getLocationCoordinate(), completion: { [weak self] polyloneString in

                self?.setCameraIncludingUserLocationAndDestination(userLocation: userLocation)

                self?.drawPolyline(polylineString: polyloneString)
            })
        })
    }

    private func setCameraIncludingUserLocationAndDestination(userLocation: CLLocation) {

        travelNoteMapView.isUserLocationEnabled(bool: true)

        let mapBounds = GMSCoordinateBounds(coordinate: getLocationCoordinate(), coordinate: userLocation.coordinate)

        travelNoteMapView.setMapBoundsTo(bounds: mapBounds)
    }

    private func drawPolyline(polylineString: String) {

        deletePreviousPolyline()

        let path = GMSMutablePath(fromEncodedPath: polylineString)

        let polyline = GMSPolyline(path: path)

        travelNoteMapView.addPolyline(polyline: polyline)

        polyline.strokeWidth = 5

        polyline.strokeColor = .red

        previousPolyline = polyline
    }

    private func deletePreviousPolyline() {

        if previousPolyline != nil {

            previousPolyline!.map = nil
        }
    }

    private func getLocationCoordinate() -> CLLocationCoordinate2D {

        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
