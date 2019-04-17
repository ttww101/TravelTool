//
//  CityPictureSliderViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/2.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class CityPictureSliderViewController: UIViewController, CityPictureSliderDelegate {

    lazy var contentView: CityPictureSliderView = CityPictureSliderView(delegate: self)

    let screenWidth = UIScreen.main.bounds.width

    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    func setUp() {

        view.backgroundColor = UIColor.white

        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: CityPictureSliderDelegate
    func pageControlDidChange(_ sender: UIPageControl) {

        let currentPage = sender.currentPage + 1

        let width = CGFloat(currentPage) * screenWidth

        let point = CGPoint(x: width, y: 0)

        contentView.setScrollViewContentOffect(point: point, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.x == 0 {

            scrollView.scrollRectToVisible(
                CGRect(origin: CGPoint(x: 4 * screenWidth, y: 0),
                            size: scrollView.frame.size),
                animated: false)

        } else if scrollView.contentOffset.x == 5 * screenWidth {

            scrollView.scrollRectToVisible(
                CGRect(origin: CGPoint(x: screenWidth, y: 0),
                            size: scrollView.frame.size),
                animated: false)
        }

        let contentOffset = scrollView.contentOffset.x

        let currentPage: Int = Int( contentOffset / screenWidth - 1 )

        contentView.setCurrentPage(page: currentPage)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentView.setScrollViewContentOffect(point: CGPoint(x: screenWidth, y: 0), animated: false)

        contentView.setCurrentPage(page: 0)

        timer.invalidate()

        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(addPageControlCurrentValue), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer.invalidate()
    }

    func addPageControlCurrentValue() {

        contentView.timerFired()
    }
}
