//
//  TravelNoteErrorHandler.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//
import UIKit

struct TravelNoteErrorHandler {

    let alertController = UIAlertController()

    func alert(error: ErrorEnum, with completion: @escaping () -> Void = {}) -> UIAlertController {

        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in

            completion()
        })

        alertController.addAction(action)

        switch error {

        case .journeyNameEmptyError:

            alertController.title = "Error"

            alertController.message = "Journey Name Should Not Be Empty."

            return alertController

        case .startDayEmptyError:

            alertController.title = "Error"

            alertController.message = "Start Day Should Not Be Empty."

            return alertController

        case .endDayEmptyError:

            alertController.title = "Error"

            alertController.message = "End Day Should Not Be Empty."

            return alertController

        case .dateTimeError:

            alertController.title = "Error"

            alertController.message = "Start Date Should Not Later Than End Date."

            return alertController

        case .networkError:

            alertController.title = "Warning !!"

            alertController.message = "Can't detect any internet service. You can use app, but your data will not be persisted. Please check your network connection for better performance."

            return alertController
        }
        //ToDo: Show alert controller on the rootViewController of the main window
    }
}
