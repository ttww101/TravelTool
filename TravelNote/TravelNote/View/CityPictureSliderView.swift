//
//  CityPictureSliderView.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/2.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class CityPictureSliderView: UIView {

    private let scrollView = UIScrollView()

    private let circleTaitungImageView = UIImageView(image: UIImage(named: "view1"))

    private let taipeiImageView = UIImageView(image: UIImage(named: "view2"))

    private let nightMarketImageView = UIImageView(image: UIImage(named: "view3"))

    private let kaohsiungImageView = UIImageView(image: UIImage(named: "view4"))

    private let taitungImageView = UIImageView(image: UIImage(named: "view1"))

    private let circleTaipeiImageView = UIImageView(image: UIImage(named: "view2"))

    private let pageControl = UIPageControl()

    weak var delegate: CityPictureSliderDelegate?

    init(delegate: CityPictureSliderDelegate) {

        self.delegate = delegate

        super.init(frame: CGRect.zero)

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {

        setScrollViewConstraints()

        setCircleTaitungImageViewConstraints()

        setTaipeiImageViewConstraints()

        setKaohsiungImageViewConstraints()

        setNightMarketImageViewConstraints()

        setTaitungImageViewConstraints()

        setCircleTaipeiImageViewConstraints()

        setPageControlConstraints()

        setUpImageViewContentMode()
    }

    func setCurrentPage(page: Int) {

        pageControl.currentPage = page
    }

    func setScrollViewContentOffect(point: CGPoint, animated: Bool) {

        scrollView.setContentOffset(point, animated: animated)
    }

    func timerFired() {

        let screenWidth = UIScreen.main.bounds.width

        let point = scrollView.contentOffset

        scrollView.setContentOffset(
            CGPoint.init(x: point.x + screenWidth, y: 0),
            animated: true)
    }

    private func setScrollViewConstraints() {

        makeSubviewContraints(subViews: [scrollView])

        scrollView.bounces = false

        scrollView.showsVerticalScrollIndicator = false

        scrollView.showsHorizontalScrollIndicator = false

        scrollView.delegate = self.delegate

        scrollView.isPagingEnabled = true
    }

    private func setCircleTaitungImageViewConstraints() {

        scrollView.addSubview(circleTaitungImageView)

        circleTaitungImageView.contentMode = .scaleAspectFill

        circleTaitungImageView.translatesAutoresizingMaskIntoConstraints = false

        circleTaitungImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        circleTaitungImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        circleTaitungImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true

        circleTaitungImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        circleTaitungImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setTaipeiImageViewConstraints() {

        scrollView.addSubview(taipeiImageView)

        taipeiImageView.contentMode = .scaleAspectFill
        
        taipeiImageView.translatesAutoresizingMaskIntoConstraints = false
        
        taipeiImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        taipeiImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        taipeiImageView.leadingAnchor.constraint(equalTo: circleTaitungImageView.trailingAnchor).isActive = true
        
        taipeiImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        taipeiImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

   private func setKaohsiungImageViewConstraints() {

        scrollView.addSubview(kaohsiungImageView)

        kaohsiungImageView.contentMode = .scaleAspectFill

        kaohsiungImageView.translatesAutoresizingMaskIntoConstraints = false

        kaohsiungImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        kaohsiungImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        kaohsiungImageView.leadingAnchor.constraint(equalTo: taipeiImageView.trailingAnchor).isActive = true

        kaohsiungImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        kaohsiungImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setNightMarketImageViewConstraints() {

        scrollView.addSubview(nightMarketImageView)

        nightMarketImageView.contentMode = .scaleAspectFill

        nightMarketImageView.translatesAutoresizingMaskIntoConstraints = false

        nightMarketImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        nightMarketImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        nightMarketImageView.leadingAnchor.constraint(equalTo: kaohsiungImageView.trailingAnchor).isActive = true

        nightMarketImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        nightMarketImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setTaitungImageViewConstraints() {

        scrollView.addSubview(taitungImageView)

        taitungImageView.contentMode = .scaleAspectFill

        taitungImageView.translatesAutoresizingMaskIntoConstraints = false

        taitungImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        taitungImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        taitungImageView.leadingAnchor.constraint(equalTo: nightMarketImageView.trailingAnchor).isActive = true

        taitungImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        taitungImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setCircleTaipeiImageViewConstraints() {

        scrollView.addSubview(circleTaipeiImageView)

        circleTaipeiImageView.contentMode = .scaleAspectFill

        circleTaipeiImageView.translatesAutoresizingMaskIntoConstraints = false

        circleTaipeiImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        circleTaipeiImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        circleTaipeiImageView.leadingAnchor.constraint(equalTo: taitungImageView.trailingAnchor).isActive = true

        circleTaipeiImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        circleTaipeiImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        circleTaipeiImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }

    private func setPageControlConstraints() {

        addSubview(pageControl)

        pageControl.translatesAutoresizingMaskIntoConstraints = false

        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        pageControl.pageIndicatorTintColor = UIColor.gray

        pageControl.currentPageIndicatorTintColor = UIColor.white

        pageControl.numberOfPages = 4

        pageControl.currentPage = 0

        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }

    private func setUpImageViewContentMode() {

        circleTaitungImageView.clipsToBounds = true

        taipeiImageView.clipsToBounds = true

        nightMarketImageView.clipsToBounds = true

        kaohsiungImageView.clipsToBounds = true

        taitungImageView.clipsToBounds = true

        circleTaipeiImageView.clipsToBounds = true
    }

    @objc private func pageControlDidChange(_ sender: UIPageControl) {

        delegate?.pageControlDidChange(sender)
    }
}

protocol CityPictureSliderDelegate: class, UIScrollViewDelegate {

    func pageControlDidChange(_: UIPageControl)
}
