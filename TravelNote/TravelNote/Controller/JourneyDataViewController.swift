//
//  JourneyDataViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/3.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class JourneyDataViewController: UIViewController {

    let isDatePicker: Bool

    let label = UILabel()

    let labelText: String

    let distance: CGFloat = 20

    let textField = AddJourneyTextField()

    let datePicker = UIDatePicker()

    let leftArrow = ArrowButton()

    let rightArrow = ArrowButton()

    let dataType: AddJourneyDataType

    var forwardTouchedHandler: ((AddJourneyDataType) -> Void)?

    var backTouchedHandler: ((AddJourneyDataType) -> Void)?

    lazy var dateHandler = DateHandler()

    init(isDatePicker: Bool, text: String, dataType: AddJourneyDataType) {

        self.isDatePicker = isDatePicker

        self.labelText = text

        self.dataType = dataType
        

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if labelText == "开始日期" {
            let dateString = dateHandler.transferTimeIntervalToString(timeInterval: Date().timeIntervalSince1970)
            
            textField.text = dateString
        }
        
        if labelText == "结束日期" {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            let dateString = dateHandler.transferTimeIntervalToString(timeInterval: tomorrow!.timeIntervalSince1970)
            textField.text = dateString
        }

        if !isDatePicker {

            textField.becomeFirstResponder()
        }
    }

    private func setUp() {

        view.backgroundColor = UIColor.darkGray

        setUpLable()

        setUpTextField()

        if isDatePicker {

            textField.inputView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))

            setUpDatePicker()
        }

        setUpArrowImageView()
    }

    private func setUpLable() {

        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        label.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: distance).isActive = true

        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: distance + 10).isActive = true

        label.text = labelText

        label.font = UIFont.appFont(size: 20)

        label.textColor = UIColor.white
    }

    private func setUpTextField() {

        view.addSubview(textField)

        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: distance).isActive = true

        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: distance).isActive = true

        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * distance).isActive = true

        textField.textColor = UIColor.black
    }

    private func setUpDatePicker() {
        if labelText == "结束日期" {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            datePicker.date = tomorrow!
        }
        
        datePicker.minimumDate = dateHandler.minimumDate()

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

        datePicker.locale = Locale(identifier: "zh_Hans_CN")

        datePicker.datePickerMode = .date

        datePicker.setValue(UIColor.white, forKeyPath: "textColor")

        datePicker.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(datePicker)

        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        datePicker.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setUpArrowImageView() {

        view.addSubview(leftArrow)

        leftArrow.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)

        leftArrow.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        leftArrow.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        leftArrow.addTarget(self, action: #selector(moveBackward), for: .touchUpInside)

        view.addSubview(rightArrow)

        rightArrow.setImage(#imageLiteral(resourceName: "next").withRenderingMode(.alwaysTemplate), for: .normal)

        rightArrow.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        rightArrow.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        rightArrow.addTarget(self, action: #selector(moveForward), for: .touchUpInside)
    }

    func moveForward() {

        forwardTouchedHandler?(dataType)
    }

    func moveBackward() {

        backTouchedHandler?(dataType)
    }

    func datePickerValueChanged(_ sender: UIDatePicker) {

        let dateString = dateHandler.transferTimeIntervalToString(timeInterval: sender.date.timeIntervalSince1970)

        textField.text = dateString
    }

    func getTextFieldText() -> String {

        return textField.text ?? ""
    }

    func setTextFieldText(text: Any) {

        if let text = text as? String {

            textField.text = text

        } else if let timeInterval = text as? Double {

            textField.text = dateHandler.transferTimeIntervalToString(timeInterval: timeInterval)

            datePicker.setDate(dateHandler.transferTimeIntervalSince1970ToDate(timeInterval: timeInterval), animated: false)
        }

        return
    }
}

class ArrowButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {

        translatesAutoresizingMaskIntoConstraints = false

        tintColor = UIColor.white

        widthAnchor.constraint(equalToConstant: 50).isActive = true

        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
