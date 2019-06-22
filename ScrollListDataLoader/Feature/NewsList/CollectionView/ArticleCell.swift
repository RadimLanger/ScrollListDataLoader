//
//  ArticleCell.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 21/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class ArticleCell: UICollectionViewCell {

    static let preferredHeight: CGFloat = 200

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        return label
    }()

    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = #imageLiteral(resourceName: "default_news")
        imgView.clipsToBounds = true
        return imgView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        clipsToBounds = true
        [imageView, titleLabel].forEach(addSubview)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 8
        let imageHeight: CGFloat = 100
        imageView.frame.size = CGSize(width: contentView.frame.size.width, height: imageHeight)

        titleLabel.frame.size.width = contentView.frame.width - padding * 4
        titleLabel.frame.size.height = contentView.frame.height - imageHeight - padding * 2
        titleLabel.frame.origin.x = padding * 2
        titleLabel.frame.origin.y = imageHeight + padding
    }

    func setup(with model: Article) {
        titleLabel.text = model.title
        fetchAndLoadImage(for: model.urlToImage)
    }

    private func fetchAndLoadImage(for urlString: String?) {
        guard let imageURLString = urlString, urlString?.suffix(4) == ".jpg" else {
            imageView.image = #imageLiteral(resourceName: "default_news")
            return
        }

        HttpClientImpl(urlSession: .shared).downloadImage(
            for: imageURLString,
            chacheEnabled: true
        ) { urlString, image in
            DispatchQueue.main.async {
                if imageURLString == urlString, image != nil {
                    self.imageView.image = image
                } else {
                    self.imageView.image = #imageLiteral(resourceName: "default_news")
                }
            }
        }
    }
}
