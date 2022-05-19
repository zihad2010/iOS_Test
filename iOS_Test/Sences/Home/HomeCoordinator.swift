//
//  HomeCoordinator.swift
//  iOS_Test
//
//  Created by Maya on 19/5/22.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator,CoordinatorProtocol {
    
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private unowned var navigationController: UINavigationController
    public weak var coordinator: CoordinatorProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller: HomeVC = .instantiate()
        navigationController.pushViewController(controller, animated: true)
        bindToLifecycle(of: controller)
    }
}
