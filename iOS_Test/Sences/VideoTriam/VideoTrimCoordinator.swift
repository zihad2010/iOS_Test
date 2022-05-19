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
    private var url: URL
    
    init(navigationController: UINavigationController,url: URL,controller: VideoTrimVC = VideoTrimVC()) {
        self.navigationController = navigationController
        self.controller = controller
        self.url = url
    }
        
    func start() {
        controller = .instantiate()
        controller.coordinator = self
        controller.url = self.url
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(controller, animated: true)
        bindToLifecycle(of: controller)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
}
