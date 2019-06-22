//
//  AppDelegate.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 20/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appCoordinator = AppCoordinator()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        appCoordinator.start()

        return true
    }
}

