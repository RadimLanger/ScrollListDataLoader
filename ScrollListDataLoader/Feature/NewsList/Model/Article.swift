//
//  Article.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

struct ArticleResponse: Decodable {
    let status: String
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?

    struct Source: Decodable {
        let name: String
    }
}
