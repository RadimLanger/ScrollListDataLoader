//
//  LoadingIndicatorCell.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class LoadingIndicatorCell: UICollectionViewCell {

    static let preferredHeight: CGFloat = 50

    let loadingIndicator = UIActivityIndicatorView(style: .gray)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadingIndicator.sizeToFit()
        loadingIndicator.frame.size.width = contentView.frame.width
        loadingIndicator.center.y = contentView.frame.height / 2
    }
}
