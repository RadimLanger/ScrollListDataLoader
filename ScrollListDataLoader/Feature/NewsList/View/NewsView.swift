//
//  NewsView.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 21/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class NewsView: UIView {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .white
        collectionView.backgroundColor = UIColor(named: "SeparatorColor")
        addSubview(collectionView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = frame
    }
}
