//
//  TravelNoteNetworkHandler.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/2.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//
import Firebase

class TravelNoteNetworkHandler {

    static let shared: TravelNoteNetworkHandler = TravelNoteNetworkHandler()

    lazy var ref = FIRDatabase.database().reference()

    let usersNode = StringEnum.users.rawValue

    var successHandler: ((JourneyDataModel) -> Void)?

    var errorHandler: ((ErrorEnum, User?) -> Void)?

    private init() { }

    func signInAnonymously(successHandler: @escaping (JourneyDataModel) -> Void, errorHandler: @escaping (ErrorEnum, User?) -> Void) {

        self.successHandler = successHandler

        self.errorHandler = errorHandler

        let flag = UserDefaults.standard.bool(forKey: StringEnum.isNotFirstOpenApp.rawValue)

        if flag {

            firebaseSignInAnonymously()

        } else {

            firstOpenThisApp()
        }
    }

    private func firebaseSignInAnonymously() {

        FIRAuth.auth()?.signInAnonymously(completion: { [weak self] (responseUser, error) in

            //Even the internet coonect is broken, this will not show error.
            if (error as NSError?) != nil {

                DispatchQueue.main.async { [weak self] in
                    self?.errorHandler?(ErrorEnum.networkError, nil)
                }

                return
            }

            guard let firUser = responseUser else { return }

            let user = User(uid: firUser.uid)

            DispatchQueue.main.async {
                self?.successHandler?(JourneyDataModel(user: user))
            }
        })
    }

    private func firstOpenThisApp() {

        FIRAuth.auth()?.signInAnonymously(completion: {[weak self] (user, error) in

            if (error as NSError?) != nil {

                DispatchQueue.main.async { [weak self] in
                    self?.errorHandler?(ErrorEnum.networkError, nil)
                }

                return
            }

            guard let firUser = user else { return }

            self?.addSampleJourney(with: firUser.uid)
        })
    }

    private func addSampleJourney(with uid: String) {

        if !Reachability.isConnectedToNetwork() {

            networkErrorHandler(uid: uid)

            return
        }
        //Handle network error

        ref.child(StringEnum.samples.rawValue).child(StringEnum.journeys.rawValue).observeSingleEvent(of: .value, with: { [weak self] snapshot in

            guard let dict = snapshot.value as? [String: Any] else { return }

            guard let journey = Journey.getJourneyWith(dictionary: dict, key: UUID().uuidString) else { return }

            self?.ref.child(StringEnum.journeys.rawValue).child(journey.key).updateChildValues([

                StringEnum.name.rawValue: journey.name,
                StringEnum.startDay.rawValue: journey.startDay,
                StringEnum.endDay.rawValue: journey.endDay,
                StringEnum.days.rawValue: journey.days,
                uid: 1

            ])

            self?.addSampleLocation(with: journey, uid: uid)
        })
    }

    private func addSampleLocation(with journey: Journey, uid: String) {

        if !Reachability.isConnectedToNetwork() {

            networkErrorHandler(uid: uid)

            return
        }

        ref.child(StringEnum.samples.rawValue).child(StringEnum.locations.rawValue).observeSingleEvent(of: .value, with: { [weak self] snapshot in

            for child in snapshot.children {

                guard let snap = child as? FIRDataSnapshot else { return }

                guard let dict = snap.value as? [String: Any] else { return }

                guard let location = Location.createLocationObject(with: dict, parentKey: journey.key, key: snap.key) else { return }

                self?.ref.child(StringEnum.locations.rawValue).child(location.parentKey).child(location.key).updateChildValues(

                    [
                        "name": location.name,
                        "latitude": location.latitude,
                        "longitude": location.longitude,
                        "webSite": location.website?.absoluteString ?? "",
                        "day": location.day,
                        "sequency": location.sequency,
                        "parentKey": location.parentKey
                    ])
            }

            UserDefaults.standard.set(true, forKey: StringEnum.isNotFirstOpenApp.rawValue)

            self?.ref.child(StringEnum.users.rawValue).child(UUID().uuidString).updateChildValues([

                StringEnum.uid.rawValue: uid
            ])

            DispatchQueue.main.async {
                self?.successHandler?(JourneyDataModel(user: User(uid: uid)))
            }
        })
    }

    func networkErrorHandler(uid: String) {

        DispatchQueue.main.async { [weak self] in
            self?.errorHandler?(.networkError, User(uid: uid))
        }
    }
}
