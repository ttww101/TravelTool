//
//  JourneyNetworkHandler.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import Firebase

class JourneyNetworkHandler {

    weak var delegate: JourneyNetworkHandlerDelegate?

    let journeysNode = StringEnum.journeys.rawValue

    let ref = TravelNoteNetworkHandler.shared.ref

    let uid: String

    init(delegate: JourneyNetworkHandlerDelegate, uid: String) {

        self.delegate = delegate

        self.uid = uid

        ref.child(journeysNode).keepSynced(true)
    }

    func getJourneyFromServer() {

        ref.child(journeysNode).queryOrdered(byChild: uid).queryEqual(toValue: 1).observeSingleEvent(of: .value, with: { [weak self] snapshot in

            var journeys: [Journey] = []

            for child in snapshot.children {

                guard let item = child as? FIRDataSnapshot else { return }

                guard let dict = item.value as? [String: Any] else { return }

                guard let journey = Journey.getJourneyWith(dictionary: dict, key: item.key) else { return }

                journeys.append(journey)
            }

            self?.delegate?.didGetJourneysFromNetwork(journeys: journeys)
        })
    }

    func updateNewJourney(journey: Journey) {

        updateJourney(journey: journey)

        delegate?.didAddNewJourneyToDataBase(journey: journey)
    }

    func updateEditedJourney(journey: Journey, index: Int) {

        updateJourney(journey: journey)

        delegate?.didUpdateEditedJourney(journey: journey, index: index)
    }

    private func updateJourney(journey: Journey) {

        ref.child(journeysNode).child(journey.key).updateChildValues(
            [
                "name": journey.name,
                "startDay": journey.startDay,
                "endDay": journey.endDay,
                "days": journey.days,
                uid: 1
            ]
        )
    }

    func deleteJourneyInServer(journey: Journey, index: Int) {

        ref.child(journeysNode).child(journey.key).removeValue()

        delegate?.didRemoveJourneyInServer(index: index)
    }
}

protocol JourneyNetworkHandlerDelegate: class {

    func didGetJourneysFromNetwork(journeys: [Journey])

    func didAddNewJourneyToDataBase(journey: Journey)

    func didRemoveJourneyInServer(index: Int)

    func didUpdateEditedJourney(journey: Journey, index: Int)
}
