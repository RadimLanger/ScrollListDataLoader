//
//  NewsCollectionDataSource.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

enum NewsCollectionDataSourceItem {
    case article
    case loadingIndicator
}

final class NewsCollectionDataSource: CollectionDataSource<NewsCollectionDataSourceItem> {


    override func cellDescriptor(for item: NewsCollectionDataSourceItem) -> CollectionCellDescriptor {
        switch item {
            case .article:          return article()
            case .loadingIndicator: return loadingIndicatorDescriptor

        }
    }

    private func article() -> CollectionCellDescriptor {
        return .init(cellClass: ArticleCell.self, configure: { cell in
            // todo: setup
        })
    }

    private let loadingIndicatorDescriptor = CollectionCellDescriptor(cellClass: LoadingIndicatorCell.self)
}
