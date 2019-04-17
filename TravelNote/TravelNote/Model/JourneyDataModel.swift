//
//  JourneyDataModel.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/2.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import Foundation

class JourneyDataModel: JourneyNetworkHandlerDelegate {

    private let user: User

    private var journeys: [Journey] = []

    private lazy var networkHandler: JourneyNetworkHandler = JourneyNetworkHandler(delegate: self, uid: self.user.uid)

    init(user: User) {

        self.user = user
    }

    func getJourneys() {

        networkHandler.getJourneyFromServer()
    }

    func numberOfJourneys() -> Int {

        return journeys.count
    }

    func journeyNameOf(index: Int) -> String {

        return journeys[index].name
    }

    func addNewJourney(journey: Journey) {

        networkHandler.updateNewJourney(journey: journey)
    }

    func editJourney(journey: Journey, index: Int) {

        networkHandler.updateEditedJourney(journey: journey, index: index)
    }

    func deleteJourney(at index: Int) {

        networkHandler.deleteJourneyInServer(journey: journeys[index], index: index)
    }

    func getJourneyWith(index: Int) -> Journey? {

        if index >= journeys.count || index < 0 {

            return nil
        }

        return journeys[index]
    }

    private func postNotification() {

        let notification = StringEnum.journeyDataModelNotification.rawValue

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notification), object: nil)
        }
    }

    // MARK: JourneyNetworkHandlerDelegate

    func didGetJourneysFromNetwork(journeys: [Journey]) {

        self.journeys = journeys

        postNotification()
    }

    func didAddNewJourneyToDataBase(journey: Journey) {

        journeys.insert(journey, at: 0)

        postNotification()
    }

    func didRemoveJourneyInServer(index: Int) {

        journeys.remove(at: index)

        postNotification()
    }

    func didUpdateEditedJourney(journey: Journey, index: Int) {

        journeys[index] = journey

        postNotification()
    }
}
