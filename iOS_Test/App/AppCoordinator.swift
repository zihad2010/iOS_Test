//
//  AppCoordinator.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import Foundation
import UIKit

final class AppCoordinator: CoordinatorProtocol {
    
    private let navigationController = UINavigationController()
    var childCoordinators: [CoordinatorProtocol] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
        homeCoordinator.start()
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
