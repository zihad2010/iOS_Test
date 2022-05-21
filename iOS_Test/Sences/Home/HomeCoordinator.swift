//
//  HomeCoordinator.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator,CoordinatorProtocol {
    
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private unowned var navigationController: UINavigationController
    public weak var coordinator: CoordinatorProtocol?
    private unowned var controller: HomeVC
    
    init(navigationController: UINavigationController,controller: HomeVC = HomeVC()) {
        self.navigationController = navigationController
        self.controller = controller
    }
        
    func start() {
        controller = .instantiate()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
        bindToLifecycle(of: controller)
    }
    
    func navigateToVideoTrimVCWith(videoUrl: URL){
        self.sanityCheck()
        let coordinator = VideoTrimCoordinator(navigationController: self.navigationController,url: videoUrl)
        addChild(coordinator)
        coordinator.start()
    }
}

extension HomeCoordinator{
    func sanityCheck() {
       print(childCoordinators)
    }
}
