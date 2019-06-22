//
//  NewsCollectionDataSource.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

enum NewsCollectionDataSourceItem: Equatable {
    case article(Article)
    case loadingIndicator
}

final class NewsCollectionDataSource: CollectionDataSource<NewsCollectionDataSourceItem> {

    var isBottomLoadingIndicatorVisible = true {
        didSet {
            reloadData()
        }
    }

    var articles = [Int: [Article]]() {
        didSet {
            reloadData()
        }
    }

    var allArticles: [Article] {
        return articles.values.reduce([], +)
    }

    private var sortedArticles: [Article] {
        var finalArticles = [Article]()

        articles.keys.sorted().forEach({
            finalArticles += self.articles[$0] ?? []
        })

        return finalArticles
    }

    init() {
        super.init(sections: [Section(items: [.loadingIndicator])])
    }

    override func cellDescriptor(for item: NewsCollectionDataSourceItem) -> CollectionCellDescriptor {
        switch item {
            case .article(let article): return articleDescriptor(article)
            case .loadingIndicator:     return loadingIndicatorDescriptor
        }
    }

    private func reloadData() {

        var items = sortedArticles.map(NewsCollectionDataSourceItem.article)
        if isBottomLoadingIndicatorVisible {
            items += [.loadingIndicator]
        }
        sections = [Section(items: items)]
    }

    private func articleDescriptor(_ article: Article) -> CollectionCellDescriptor {
        return .init(cellClass: ArticleCell.self, configure: { cell in
            cell.setup(with: article)
        })
    }

    private var loadingIndicatorDescriptor: CollectionCellDescriptor {
        return .init(cellClass: LoadingIndicatorCell.self, configure: { cell in
            cell.loadingIndicator.startAnimating()
        })
    }
}
