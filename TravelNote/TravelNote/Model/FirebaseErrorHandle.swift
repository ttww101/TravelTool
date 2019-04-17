//
//  FirebaseErrorHandle.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/25.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import Foundation
import Firebase

class FirebaseErrorHandle {

    func firebaseErrorHandle(error: NSError) {

        if let errCode = FIRAuthErrorCode(rawValue: error.code) {

            switch errCode {

            case .errorCodeNetworkError:

                print("====================")
                print("Network error")

            case .errorCodeTooManyRequests:

                print("====================")
                print("Too many requests")

            default:

                print("YA")
            }
        }
    }
}
