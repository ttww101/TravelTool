//
//  UIKitExtension.swift
//  TravelNote
//
//  Created by 伍智瑋 on 2017/4/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

extension UIFont {

    static func appFont(size: CGFloat) -> UIFont {

        if let font = UIFont(name: "EuphemiaUCAS-Bold", size: size) {

            return font

        }

        return systemFont(ofSize: size)
    }
}

extension UIColor {

    static func hexStringToUIColor ( hex: String ) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.characters.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0

        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(

            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,

            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,

            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,

            alpha: CGFloat(1.0)
        )
    }

    static func colorWithoutDivider(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {

        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)

    }

}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {

        view.endEditing(true)
    }
}

extension UIStoryboard {

    static func initController(in storyboard: String, withIdentifier identifier: String) -> UIViewController {

        let storyboard = UIStoryboard(name: storyboard, bundle: nil)

        let controller = storyboard.instantiateViewController(withIdentifier: identifier)

        return controller

    }
}

extension UIView {

    func makeSubviewContraints(subViews: [UIView]) {

        for childView in subViews {

            childView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(childView)

            childView.topAnchor.constraint(equalTo: topAnchor).isActive = true

            childView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

            childView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

            childView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
