//
//  CoordinatorProtocol.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] {get}
    func start()
    func popViewController()
    func sanityCheck()
}
extension CoordinatorProtocol{
    func popViewController(){}
    func sanityCheck(){}
}


