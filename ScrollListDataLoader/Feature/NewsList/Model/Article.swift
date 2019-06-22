//
//  Article.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

struct ArticleResponse: Decodable {
    let status: String
    let message: String?
    let articles: [Article]?
}

struct Article: Decodable, Equatable {
    let title: String
    let urlToImage: String?
}
