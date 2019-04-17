//
//  LocationTableViewController.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/3/27.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationTableViewController: UIViewController, GMSAutocompleteResultsViewControllerDelegate, LocationDataModelDelegate {

    let tableView = LocationTableView()

    let dataModel: LocationDataModel

    var specificDay: Int

    var slidehandler: (() -> Void)?

    weak var delegate: LocationTableViewControllerDelegate?

    init(with locationDataModel: LocationDataModel, specificDay: Int) {

        self.dataModel = locationDataModel

        self.specificDay = specificDay

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel.delegate = self

        DispatchQueue.global().async { [weak self] in
            self?.dataModel.loadLocationsFromFirebase()
        }

        setUp()

        setUpTableView()
    }

    private func setUp() {

        view.backgroundColor = UIColor.white

        navigationItem.title = dataModel.getJourneyName()

        automaticallyAdjustsScrollViewInsets = false
    }

    private func setUpTableView() {

        tableView.delegate(delegate: self)

        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(userDidSlideOnTheCell)))

        tableView.registerNib(classes: [LocationTableViewCell.self, SearchTableViewCell.self])
    }

    func search(_ sender: UIButton) {

        let searchResultController = GMSAutocompleteResultsViewController()

        searchResultController.delegate = self

        let searchController = UISearchController(searchResultsController: searchResultController)

        searchController.searchResultsUpdater = searchResultController

        self.present(searchController, animated: true, completion: nil)
    }

    func setNewSpecificDay(specificDay: Int) {

        self.specificDay = specificDay

        locationDataUpdate()

        DispatchQueue.global().async { [weak self] in

            guard let holdSelf = self else { return }

            holdSelf.dataModel.loadTravelTimeWith(specificDay: holdSelf.specificDay)
        }
    }

    // MARK: Slide back function
    func userDidSlideOnTheCell() {

        slidehandler?()
    }

    // MARK: GMSAutocompleteResultsViewControllerDelegate

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {

        makeDataModelCreateLocationWith(place: place)

        resultsController.parent?.dismiss(animated: true, completion: nil)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {

        print(error)

        resultsController.parent?.dismiss(animated: true, completion: nil)
    }

    func locationDataUpdate() {

        tableView.reloadData()
    }

    func transferToMin(second: Int) -> String {

        if second == -1 {

            return ""

        } else {

            return "About " + String( second / 60 + 1 ) + " mins"
        }
    }

    func makeDataModelCreateLocationWith(place: GMSPlace) {

        var website = ""

        if let urlString = place.website?.absoluteString {

            website = urlString
        }

        dataModel.createLocation(name: place.name, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, website: website, specificDay: specificDay)
    }

    // MARK: LocationDataModelDelegate

    func didSetLocationsInDataModel() {

        locationDataUpdate()

        delegate?.didGetLocations()

        UIView.animate(withDuration: 0.5,

                       animations: {

                        self.tableView.alpha = 0

                        self.tableView.alpha = 1
        },
                       completion: { _ in
                        //test
                        DispatchQueue.global().async { [weak self] in

                            guard let holdSelf = self else { return }

                            holdSelf.dataModel.loadTravelTimeWith(specificDay: holdSelf.specificDay)
                        }
        })
    }

    func didAddNewLocationInDataModel(sequency: Int) {

        let indexPath = IndexPath(row: sequency, section: 0)

        self.tableView.insertRows(at: [indexPath], with: .none)

        delegate?.willAddLocationAt()
    }

    func didCalculatedTravelTimeWith(location: Location) {

        let indexPath = IndexPath(row: location.sequency, section: 0)

        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: TableView Datasource and delegate
extension LocationTableViewController: TravelNoteTableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {

        return  1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataModel.numberOfLocationIn(specificDay: specificDay)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row

        let location = dataModel.getLocationWith(day: specificDay, row: row)

        let cell = location.type.getCell(tableView: tableView, indexPath: indexPath)!

        switch location.type {

        case .normal:

            guard let normalCell = cell as? LocationTableViewCell else { return cell }

            guard let location = location as? Location else { return cell }

            normalCell.locationNameLabel.text = location.name

            normalCell.travelTimeLabel.text = transferToMin(second: location.travelTime)

            normalCell.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(userDidSlideOnTheCell)))

            return normalCell

        case .search:

            guard let searchCell = cell as? SearchTableViewCell else { return cell }

            searchCell.searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
            searchCell.addButton.addTarget(self, action: #selector(search), for: .touchUpInside)

            searchCell.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(userDidSlideOnTheCell)))

            return searchCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        guard let cellModel = dataModel.getLocationWith(day: specificDay, row: indexPath.row) as? Location else { return }

        let controller = SingleLocationViewController(location: cellModel)

        show(controller, sender: nil)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        let count = dataModel.numberOfLocationIn(specificDay: specificDay)

        if indexPath.row ==  count - 1 {

            return nil
        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            dataModel.deleteLocation(row: indexPath.row, specificDay: specificDay, completion: {[weak self] in

                tableView.deleteRows(at: [indexPath], with: .automatic)

                self?.delegate?.willRemoveLocationAt()
            })
        }
    }
}

protocol LocationTableViewControllerDelegate: class {

    func didGetLocations()

    func willRemoveLocationAt()

    func willAddLocationAt()
}
