//
//  JourneyListViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/2.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class JourneyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let dataModel: JourneyDataModel
    let tableView = UITableView()
    let slideController = CityPictureSliderViewController()
    var headerView: UIView?
    var headerViewTopLayoutConstraint: NSLayoutConstraint?
    var headerViewHeightConstraint: NSLayoutConstraint?
    lazy var dateHandler = DateHandler()
    let navigationView = JourneyNavigationView()
    let headerViewHeight: CGFloat = UIScreen.main.bounds.width * 0.66

    init(dataModel: JourneyDataModel) {
        self.dataModel = dataModel

        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "旅行助手直通车", image: UIImage(named: "home"), selectedImage: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJourney))
        title = "旅行助手直通车"
        

        UIApplication.shared.statusBarStyle = .lightContent

        if !Reachability.isConnectedToNetwork() {

            navigationView.noService()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isHidden = false

        UIApplication.shared.statusBarStyle = .default
    }

    func setUp() {

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: StringEnum.journeyDataModelNotification.rawValue), object: nil)

        DispatchQueue.global().async { [weak self] in

            self?.dataModel.getJourneys()
        }

        view.backgroundColor = UIColor.white

        automaticallyAdjustsScrollViewInsets = false

        setUpTableView()

        setUpNavigationView()

        setUpHeaderView()
    }

    func setUpTableView() {

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JourneyTableViewCell.self, forCellReuseIdentifier: JourneyTableViewCell.identifier)
        tableView.separatorStyle = .none
    }

    func setUpNavigationView() {
        view.addSubview(navigationView)
        navigationView.isHidden = true
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        navigationView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationView.addButton.addTarget(self, action: #selector(addJourney), for: .touchUpInside)
    }

    func setUpHeaderView() {
        headerView = slideController.view
        guard let headerView = headerView else { return }
        tableView.tableHeaderView = nil
        addChildViewController(slideController)
        tableView.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewTopLayoutConstraint = headerView.topAnchor.constraint(equalTo: view.topAnchor)
        headerViewTopLayoutConstraint?.isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerViewHeightConstraint?.isActive = true
        slideController.didMove(toParentViewController: self)
        tableView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if (scrollView.contentOffset.y >= -headerViewHeight) && (scrollView.contentOffset.y <= 50) {

            headerViewTopLayoutConstraint?.isActive = false
            headerViewHeightConstraint?.isActive = false

            headerViewTopLayoutConstraint = headerView?.topAnchor.constraint(equalTo: view.topAnchor,
                                                                             constant: -headerViewHeight - scrollView.contentOffset.y)

            headerViewHeightConstraint = headerView?.heightAnchor.constraint(equalToConstant: headerViewHeight)
            headerViewTopLayoutConstraint?.isActive = true
            headerViewHeightConstraint?.isActive = true
            tableView.layoutIfNeeded()
        }

        if scrollView.contentOffset.y < -headerViewHeight {

            headerViewTopLayoutConstraint?.isActive = false
            headerViewHeightConstraint?.isActive = false

            headerViewTopLayoutConstraint = headerView?.topAnchor.constraint(equalTo: view.topAnchor)
            headerViewHeightConstraint = headerView?.heightAnchor.constraint(equalToConstant: -scrollView.contentOffset.y)

            headerViewHeightConstraint?.isActive = true
            headerViewTopLayoutConstraint?.isActive = true

            tableView.layoutIfNeeded()
        }
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func addJourney() {
        let pageController = AddJourneyViewController(journey: nil, completion: { [weak self] (journey) in
            DispatchQueue.global().async {
                self?.dataModel.addNewJourney(journey: journey)
            }
        })
        pageController.setFirstViewController()
        show(pageController, sender: nil)
    }

    func editJourney(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? JourneyTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let modifiedRow = modifyIndexForDataModel(index: indexPath.row)
        guard let journey = dataModel.getJourneyWith(index: modifiedRow) else { return }
        let pageController = AddJourneyViewController(journey: journey, completion: { [weak self] (editJourney) in
            DispatchQueue.global().async {
                self?.dataModel.editJourney(journey: editJourney, index: modifiedRow)
            }
        })

        pageController.setFirstViewController()
        show(pageController, sender: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.numberOfJourneys()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getJourneyCellWith(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            DispatchQueue.global().async { [weak self] in
                guard let holdSelf = self else { return }
                holdSelf.dataModel.deleteJourney(at: holdSelf.modifyIndexForDataModel(index: indexPath.row))
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let journey = dataModel.getJourneyWith(index: modifyIndexForDataModel(index: indexPath.row)) else { return }
        let controller = MainLocationViewController(dataModel: LocationDataModel(journey: journey))
        show(controller, sender: nil)
    }

    func modifyIndexForDataModel(index: Int) -> Int {
        return index
    }

    // MARK: Manage the slider view in table view.

    func getJourneyCellWith(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JourneyTableViewCell.identifier, for: indexPath)
            as? JourneyTableViewCell else {
                return UITableViewCell(style: .default, reuseIdentifier: JourneyTableViewCell.identifier)
        }

        guard let journey = dataModel.getJourneyWith(index: modifyIndexForDataModel(index: indexPath.row)) else {
            return UITableViewCell(style: .default, reuseIdentifier: JourneyTableViewCell.identifier)
        }

        cell.setJourneyName(name: journey.name)
        cell.setJourneyDate(date: dateHandler.transferTimeIntervalToString(timeInterval: journey.startDay), days: String(journey.days + 1 ))
        cell.setJourneyImage(index: indexPath.row)
        cell.editButton.addTarget(self, action: #selector(editJourney), for: .touchUpInside)

        return cell
    }
}
