//
//  RightRadiousView.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 21/5/22.
//

import UIKit

class RightRadiousView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskPath = UIBezierPath.init(roundedRect: self.self.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize.init(width: 5.0, height: 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
