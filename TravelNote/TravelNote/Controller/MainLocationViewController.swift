//
//  MainLocationViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/28.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class MainLocationViewController: UIViewController, LocationTableViewControllerDelegate, DaySelectorViewControllerDelegate {

    let locationDataModel: LocationDataModel

    private let itemHeight: CGFloat = 60

    private let itemWidth: CGFloat = 90

    var specificDay = 0

    lazy var mapController = MutipleLocationsViewController(locations: nil, zoom: 6)

    lazy var locationController: LocationTableViewController = LocationTableViewController(with: self.locationDataModel, specificDay: self.specificDay)

    lazy var daySelectorController: DaySelectorViewController = DaySelectorViewController(itemHeight: self.itemHeight, itemWidth: self.itemWidth, days: self.locationDataModel.getDays())

    var locationTableViewTopConstraint: NSLayoutConstraint?

    init(dataModel: LocationDataModel) {

        self.locationDataModel = dataModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        navigationItem.title = locationDataModel.getJourneyName()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow"), style: .done, target: self, action: #selector(pushBackToParentController))

        navigationController?.navigationBar.tintColor = UIColor.black

        automaticallyAdjustsScrollViewInsets = false

        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !Reachability.isConnectedToNetwork() {

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "No Service", style: .plain, target: nil, action: nil)
        }
    }

    func setUp() {

        addDaySelectorController()

        addMapController()

        addLocationController()

        addBackgroundImageView()
    }

    func pushBackToParentController() {

        navigationController?.popViewController(animated: true)
    }

    func addDaySelectorController() {

        addChildViewController(daySelectorController)

        view.addSubview(daySelectorController.view)

        daySelectorController.view.translatesAutoresizingMaskIntoConstraints = false

        daySelectorController.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        daySelectorController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        daySelectorController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        daySelectorController.view.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true

        daySelectorController.didMove(toParentViewController: self)

        daySelectorController.delegate = self
    }

    func addMapController() {

        addChildViewController(mapController)

        view.addSubview(mapController.view)

        mapController.view.translatesAutoresizingMaskIntoConstraints = false

        mapController.view.topAnchor.constraint(equalTo: daySelectorController.view.bottomAnchor).isActive = true

        mapController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        mapController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        mapController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true

        mapController.didMove(toParentViewController: self)

        mapController.isHidden(bool: true)
    }

    func addLocationController() {

        locationController.delegate = self

        locationController.slidehandler = { [unowned self] in

            self.slideToGoBack()
        }

        addChildViewController(locationController)

        view.addSubview(locationController.view)

        locationController.view.translatesAutoresizingMaskIntoConstraints = false

        locationTableViewTopConstraint = locationController.view.topAnchor.constraint(equalTo: mapController.view.bottomAnchor)

        locationTableViewTopConstraint?.isActive = true

        locationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        locationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        locationController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        locationController.didMove(toParentViewController: self)
    }

    func addBackgroundImageView() {

        let imageView = UIImageView(image: #imageLiteral(resourceName: "AppIconOrigin"))

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit

        imageView.clipsToBounds = true

        view.addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: mapController.view.bottomAnchor, constant: 100).isActive = true

        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true

        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true

        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true

        view.sendSubview(toBack: imageView)
    }

    func slideToGoBack() {

        navigationController?.popViewController(animated: true)
    }

    // MARK: LocationTableViewControllerDelegate

    func didGetLocations() {

        setMapControllerReload()
    }

    func willRemoveLocationAt() {

        setMapControllerReload()
    }

    func willAddLocationAt() {

        setMapControllerReload()
    }

    func setMapControllerReload() {

        let locations = locationDataModel.getLocations(specificDay: specificDay)

        mapController.travelNoteMapView.replaceLocations(as: locations)
    }

    // MARK: DaySelectorViewControllerDelegate

    func didSelectSpecificDay(specificDay: Int) {

        self.specificDay = specificDay

        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in

                        guard let holdSelf = self else { return }

                        holdSelf.mapController.travelNoteMapView.clear()

                        holdSelf.locationTableViewTopConstraint?.isActive = false

                        holdSelf.locationTableViewTopConstraint = holdSelf.locationController.view.topAnchor.constraint(equalTo: holdSelf.view.bottomAnchor)

                        holdSelf.locationTableViewTopConstraint?.isActive = true

                        holdSelf.view.layoutIfNeeded()
        },
                       completion: { [weak self] _ in

                        guard let holdSelf = self else { return }

                        holdSelf.locationController.setNewSpecificDay(specificDay: specificDay)

                        holdSelf.setMapControllerReload()

                        UIView.animate(withDuration: 0.3, animations: { [weak self] in

                            guard let holdSelf = self else { return }

                            holdSelf.locationTableViewTopConstraint?.isActive = false

                            holdSelf.locationTableViewTopConstraint = holdSelf.locationController.view.topAnchor.constraint(equalTo: holdSelf.mapController.view.bottomAnchor)

                            holdSelf.locationTableViewTopConstraint?.isActive = true

                            holdSelf.view.layoutIfNeeded()
                        })
        })
    }
}
