//
//  Border.swift
//  iOS_Test
//
//  Created by Maya on 20/5/22.
//

import UIKit

class ABBorder: UIView {

    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = UIColor(red: 119.0/255, green: 79.0/255, blue: 194.0/255, alpha: 1.0)
        imageView.frame = self.bounds
        imageView.contentMode = UIView.ContentMode.scaleToFill
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }

}
