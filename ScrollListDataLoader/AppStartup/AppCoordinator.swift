//
//  AppCoordinator.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window = UIWindow(frame: UIScreen.main.bounds)

    private let newsController = NewsViewController()
    private lazy var navigationController = UINavigationController(rootViewController: newsController)

    private let newsResource = NewsRemoteResource()

    func start() {

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        setupNewsControllerAndFetchArticles()
    }


    // Mark: - Articles

    private func setupNewsControllerAndFetchArticles() {
        newsController.delegate = self

        let pageNumberToLoad = 1
        newsResource.fetchArticles(pageNumber: pageNumberToLoad) { [weak self] in
            self?.handleArticle(result: $0, pageNumber: pageNumberToLoad)
        }
    }

    private func handleArticle(result: (Result<ArticleResponse, RequestExecutionError>), pageNumber: Int) {
        DispatchQueue.main.async { [weak self] in

            switch result {
                case .success(let articleResponse):

                    if articleResponse.status == "ok", let articles = articleResponse.articles {
                        self?.newsController.setArticles(articles, for: pageNumber)
                    } else if let message = articleResponse.message {
                        self?.showError(with: message)
                        self?.newsController.removeBottomLoadingIndicator()
                    } else {
                        self?.showError(with: "Unknown error")
                    }

                case .failure(let error):
                    self?.showError(with: String(describing: error))
            }
        }
    }

    private func showError(with reason: String) {
        let height = newsController.view.safeAreaInsets.top + 8
        navigationController.showNotification(with: reason, topInset: height )
    }
}

extension AppCoordinator: NewsViewControllerDelegate {

    func newsViewController(_ controller: NewsViewController, didScrollAtBottomWith lastLoadedPage: Int) {

        let pageNumberToLoad = lastLoadedPage + 1

        newsResource.fetchArticles(pageNumber: pageNumberToLoad) { [weak self] in
            self?.handleArticle(result: $0, pageNumber: pageNumberToLoad)
        }
    }
}
