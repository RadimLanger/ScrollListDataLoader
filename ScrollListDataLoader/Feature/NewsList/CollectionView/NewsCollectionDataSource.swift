//
//  NewsCollectionDataSource.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

enum NewsCollectionDataSourceItem {
    case article(Article)
    case loadingIndicator
}

final class NewsCollectionDataSource: CollectionDataSource<NewsCollectionDataSourceItem> {

    var articles = [Int: [Article]]() {
        didSet {
            let articleItems = sortedArticles.map(NewsCollectionDataSourceItem.article)
            sections = [Section(items: articleItems + [.loadingIndicator])]
        }
    }

    private var sortedArticles: [Article] {
        var finalArticles = [Article]()

        articles.keys.sorted().forEach({
            finalArticles += self.articles[$0] ?? []
        })

        return finalArticles
    }

    var allArticles: [Article] {
        return articles.values.reduce([], +)
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
