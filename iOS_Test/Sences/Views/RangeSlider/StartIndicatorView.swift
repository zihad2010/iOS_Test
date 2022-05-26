//
//  StartIndicator.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 20/5/22.
//

import UIKit

class StartIndicatorView: LeftRadiousView {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        imageView.frame = CGRect(x: (self.bounds.width/2) - 5, y: (self.bounds.height/2)-15, width: 10.0, height: 30.0)
        imageView.image = UIImage(named: "seek_bar")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.addSubview(imageView)
        self.backgroundColor = UIColor(red: 119.0/255, green: 79.0/255, blue: 194.0/255, alpha: 1.0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

