//
//  AddJourneyViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class AddJourneyViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    

    let nameController = JourneyDataViewController(isDatePicker: false, text: "行程名称", dataType: .name)
    let startController = JourneyDataViewController(isDatePicker: true, text: "开始日期", dataType: .startDay)
    let endController = JourneyDataViewController(isDatePicker: true, text: "结束日期", dataType: .endDay)

    var journey: Journey?

    let completion: (Journey) -> Void

    lazy var controllers: [JourneyDataViewController] = [ self.nameController, self.startController, self.endController ]

    lazy var dateHandler = DateHandler()

    init(journey: Journey?, completion: @escaping (Journey) -> Void) {
        self.journey = journey

        self.completion = completion

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        title = "添加行程"
        tabBarItem = UITabBarItem(title: "添加行程", image: UIImage(named: "add"), selectedImage: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        setUp()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.navigationBar.tintColor = UIColor.black

//        let titleDict: [String: Any] = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        let titleDict: [NSAttributedStringKey : Any] = [.foregroundColor:  UIColor.black]

        navigationController?.navigationBar.titleTextAttributes = titleDict
    }

    func setUp() {
        automaticallyAdjustsScrollViewInsets = false
//        navigationController?.navigationBar.tintColor = UIColor.white
//        let titleDict: [String: Any] = [NSForegroundColorAttributeName: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = titleDict
        view.backgroundColor = UIColor.white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(userDidPressDonButton))

        navigationItem.title = "添加行程"
        addHandler()
        self.delegate = self
        self.dataSource = self

        if let journey = journey {
            navigationItem.title = "编辑行程"
            nameController.setTextFieldText(text: journey.name)
            startController.setTextFieldText(text: journey.startDay)
            endController.setTextFieldText(text: journey.endDay)
        }
    }

    func addHandler() {

        let dataTypes = controllers.map { (viewController) -> AddJourneyDataType in

            return viewController.dataType
        }

        let forwardHandler: (AddJourneyDataType) -> Void = { [weak self] dataType in

            guard let holdSelf = self else { return }
            guard let index = dataTypes.index(of: dataType) else { return }
            var nextIndex = 0
            if index < dataTypes.count - 1 {

                nextIndex = index + 1
            }

            holdSelf.setViewControllers([holdSelf.controllers[nextIndex]], direction: .forward, animated: true, completion: nil)
        }

        let backHandler: (AddJourneyDataType) -> Void = { [weak self] dataType in

            guard let holdSelf = self else { return }

            guard let index = dataTypes.index(of: dataType) else { return }

            var lastIndex = dataTypes.count - 1

            if index > 0 {

                lastIndex = index - 1
            }

            holdSelf.setViewControllers([holdSelf.controllers[lastIndex]], direction: .reverse, animated: true, completion: nil)
        }

        nameController.forwardTouchedHandler = forwardHandler
        nameController.backTouchedHandler = backHandler

        startController.forwardTouchedHandler = forwardHandler
        startController.backTouchedHandler = backHandler

        endController.forwardTouchedHandler = forwardHandler
        endController.backTouchedHandler = backHandler
    }

    func userDidPressDonButton() {
        let journeyName = nameController.getTextFieldText()
        let startDay = startController.getTextFieldText()
        let endDay = endController.getTextFieldText()

        if let error = dateHandler.checkData(name: journeyName, startDay: startDay, endDay: endDay) {

            let errorHandler = TravelNoteErrorHandler()
            let alertController = errorHandler.alert(error: error)
            present(alertController, animated: true, completion: nil)

            return
        }

        let uuid = UUID().uuidString

        let journey = Journey(name: journeyName,
                              startDay: dateHandler.trasferStringToTimeIntervalSince1970(dateString: startDay),
                              endDay: dateHandler.trasferStringToTimeIntervalSince1970(dateString: endDay),
                              days: dateHandler.calculateDays(start: startDay, end: endDay),
                              key: self.journey?.key ?? uuid)

        completion(journey)

//        navigationController?.popViewController(animated: true)
        tabBarController?.selectedIndex = 0
    }

    func setFirstViewController() {
        setViewControllers([nameController], direction: .forward, animated: true, completion: nil)
    }

    // MARK: Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? JourneyDataViewController else { return nil}

        guard let index = controllers.index(of: viewController) else { return nil }

        if (index > 0) && (index < controllers.count) {
            return controllers[index - 1]
        } else if index == 0 {

            return controllers.last
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? JourneyDataViewController else { return nil}

        guard let index = controllers.index(of: viewController) else { return nil }

        if (index >= 0) && (index < controllers.count - 1) {
            return controllers[index + 1]

        } else if index == controllers.count - 1 {

            return controllers[0]
        }

        return nil
    }
}

enum AddJourneyDataType {

    case name

    case startDay

    case endDay
}
