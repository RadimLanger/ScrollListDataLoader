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

    private lazy var navigationController = UINavigationController(rootViewController: NewsViewController())

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
