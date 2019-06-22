//
//  NewsRemoteResource.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class NewsRemoteResource: NSObject {

    private let httpClient = HttpClientImpl(urlSession: URLSession.shared)

    private var isFetchingArticles = false

    func fetchArticles(
        pageNumber: Int,
        completion: @escaping (Result<ArticleResponse, RequestExecutionError>) -> Void
    ) {
        guard
            let url = URL(string: NewsRequestURI.everythingFromApple.urlString(pageNumber: pageNumber)),
            isFetchingArticles == false
        else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        request.addJsonContentType()
        isFetchingArticles = true
        
        httpClient.execute(request: request, ArticleResponse.self, completion: { [weak self] result in
            completion(result)
            self?.isFetchingArticles = false
        })
    }
}
