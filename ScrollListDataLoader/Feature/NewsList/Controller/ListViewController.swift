//
//  NewsViewController.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 20/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

protocol NewsViewControllerDelegate: AnyObject {
    func newsViewController(_ controller: NewsViewController, didScrollAtBottomWith lastLoadedPage: Int)
}

final class NewsViewController: UIViewController {

    weak var delegate: NewsViewControllerDelegate?

    private let rootView = NewsView()
    private let dataSource = NewsCollectionDataSource()

    private var collectionView: UICollectionView {
        return rootView.collectionView
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "News"
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }

    func setArticles(_ articles: [Article], for pageNumber: Int) {

        dataSource.articles[pageNumber] = articles
        collectionView.reloadData()
    }

    func removeBottomLoadingIndicator() {
        dataSource.isBottomLoadingIndicatorVisible = false
        collectionView.reloadData()
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
            case .article:          height = ArticleCell.preferredHeight
            case .loadingIndicator: height = LoadingIndicatorCell.preferredHeight
        }

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let item = dataSource.item(at: indexPath), item == .loadingIndicator else { return }

        let lastLoadedPage = Array(dataSource.articles.keys).max() ?? 1

        delegate?.newsViewController(self, didScrollAtBottomWith: lastLoadedPage)
    }
}
