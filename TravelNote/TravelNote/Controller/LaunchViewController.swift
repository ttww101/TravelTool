//
//  LaunchViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/23.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    let indicatorController = ActivityIndicatorViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        addChildViewController(indicatorController)

        view.addSubview(indicatorController.view)

        indicatorController.view.translatesAutoresizingMaskIntoConstraints = false
        indicatorController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        indicatorController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        indicatorController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        indicatorController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        indicatorController.didMove(toParentViewController: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let networkHandler = TravelNoteNetworkHandler.shared

        DispatchQueue.global(qos: .userInitiated).async {

            networkHandler.signInAnonymously(

                successHandler: { [weak self] dataModel in
//                    let tabBarController = UITabBarController()
//                    tabBarController.viewControllers =

                    self?.changeRootViewController(dataModel: dataModel)
                },

                errorHandler: { [weak self] (errorEnum, user) in

                    let errorHandler = TravelNoteErrorHandler()

                    let alertController = errorHandler.alert(error: errorEnum, with: {

                        guard let user = user else { return }

                        self?.changeRootViewController(dataModel: JourneyDataModel(user: user))
                    })

                    self?.present(alertController, animated: true, completion: nil)
                }
            )
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        indicatorController.willMove(toParentViewController: nil)

        indicatorController.view.removeFromSuperview()

        indicatorController.removeFromParentViewController()
    }

    func changeRootViewController(dataModel: JourneyDataModel) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let tabBarController = UITabBarController()
        let addVC = AddJourneyViewController(journey: nil, completion: { [weak self] (journey) in
            DispatchQueue.global().async {
                dataModel.addNewJourney(journey: journey)
            }
        })
        let navController = UINavigationController(rootViewController: addVC)
        
        let moreTableViewController = MoreTableViewController()
        let navController1 = UINavigationController(rootViewController: moreTableViewController)
        
        addVC.setFirstViewController()
        tabBarController.viewControllers = [JourneyListNavigationController(rootViewController: JourneyListViewController(dataModel: dataModel)), navController, navController1]
        
        
        
        appDelegate.window?.rootViewController = tabBarController
    }
}
