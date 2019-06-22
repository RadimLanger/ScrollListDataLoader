//
//  NewsRequestURI.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import Foundation

enum NewsRequestURI: String {

    case everythingFromApple = "everything?q={query}&from={from}&to={to}&sortBy={sortBy}&apiKey={apiKey}&pageSize={pageSize}&page={pageNumber}&language={language}"

    enum SortBy: String {
        case popularity
    }

    private static let dateFormatter = DateFormatter()

    func urlString(
        for query: String = "apple",
        date: Date = Date(),
        sortBy: SortBy = .popularity,
        pageSize: Int = 10, 
        language: String = "en",
        pageNumber: Int
    ) -> String {

        var urlString = Config.newsBaseURL + rawValue

        NewsRequestURI.dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = NewsRequestURI.dateFormatter.string(from: date)

        urlString = urlString.replacingOccurrences(of: "{query}", with: query)
        urlString = urlString.replacingOccurrences(of: "{from}", with: dateString)
        urlString = urlString.replacingOccurrences(of: "{to}", with: dateString)
        urlString = urlString.replacingOccurrences(of: "{sortBy}", with: sortBy.rawValue)
        urlString = urlString.replacingOccurrences(of: "{pageSize}", with: "\(pageSize)")
        urlString = urlString.replacingOccurrences(of: "{pageNumber}", with: "\(pageNumber)")
        urlString = urlString.replacingOccurrences(of: "{apiKey}", with: Config.newsApiKey)
        urlString = urlString.replacingOccurrences(of: "{language}", with: language)

        return urlString
    }
}
