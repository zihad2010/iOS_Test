//
//  VideoTrimCoordinator.swift
//  iOS_Test
//
//  Created by Maya on 19/5/22.
//

import Foundation
import UIKit

final class VideoTrimCoordinator: Coordinator,CoordinatorProtocol {
    
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private unowned var navigationController: UINavigationController
    public weak var coordinator: CoordinatorProtocol?
    private unowned var controller: VideoTrimVC
    
    init(navigationController: UINavigationController,controller: VideoTrimVC = VideoTrimVC()) {
        self.navigationController = navigationController
        self.controller = controller
    }
        
    func start() {
        controller = .instantiate()
        controller.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(controller, animated: true)
        bindToLifecycle(of: controller)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
}
