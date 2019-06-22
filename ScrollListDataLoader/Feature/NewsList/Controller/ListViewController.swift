//
//  NewsViewController.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 20/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {

    private let rootView = NewsView()
    private let dataSource = NewsCollectionDataSource()

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.collectionView.dataSource = dataSource
        rootView.collectionView.delegate = self
    }


}

extension NewsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        guard let item = dataSource.item(at: indexPath) else { return .zero }

        let width = collectionView.frame.width
        let height: CGFloat

        switch item {
            case .article:          height = 50
            case .loadingIndicator: height = LoadingIndicatorCell.preferredHeight
        }

        return CGSize(width: width, height: height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
