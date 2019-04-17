//
//  DaySelectorViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/5/5.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class DaySelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let collectionViewLayout = UICollectionViewFlowLayout()

    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)

    let itemHeight: CGFloat

    let itemWidth: CGFloat

    let days: Int

    weak var delegate: DaySelectorViewControllerDelegate?

    private var selectDay: Int = 0

    init(itemHeight: CGFloat, itemWidth: CGFloat, days: Int) {

        self.itemHeight = itemHeight

        self.itemWidth = itemWidth

        self.days = days

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.selectItem(at: IndexPath(row: selectDay, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

    func setUp() {

        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = UIColor.white

        setUpCollectionViewLayout()

        setUpCollectionView()
    }

    func setUpCollectionViewLayout() {

        collectionViewLayout.scrollDirection = .horizontal

        collectionViewLayout.minimumLineSpacing = 5

        collectionViewLayout.minimumInteritemSpacing = 5

        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

        collectionViewLayout.headerReferenceSize = CGSize(width: 0, height: 0)

        collectionViewLayout.footerReferenceSize = CGSize(width: 0, height: 0)
    }

    func setUpCollectionView() {

        collectionView.register(DaySelectorCollectionViewCell.self, forCellWithReuseIdentifier: DaySelectorCollectionViewCell.identifier)

        collectionView.dataSource = self

        collectionView.delegate = self

        collectionView.backgroundColor = UIColor.white

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.allowsMultipleSelection = false
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return days + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: DaySelectorCollectionViewCell.identifier, for: indexPath) as? DaySelectorCollectionViewCell else { return UICollectionViewCell() }

        item.label.text = "Day \(indexPath.row + 1)"

        return item
    }
    // MARK: UICollectionDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = collectionView.cellForItem(at: indexPath) as? DaySelectorCollectionViewCell else { return }

        item.changeState(highlight: true)

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

        selectDay = indexPath.row

        delegate?.didSelectSpecificDay(specificDay: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let item = collectionView.cellForItem(at: indexPath) as? DaySelectorCollectionViewCell else { return }

        item.changeState(highlight: false)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let item = cell as? DaySelectorCollectionViewCell else { return }

        if indexPath.row == selectDay {

            item.changeState(highlight: true)

            return
        }

        item.changeState(highlight: false)
    }
}

protocol DaySelectorViewControllerDelegate: class {

    func didSelectSpecificDay(specificDay: Int)
}
