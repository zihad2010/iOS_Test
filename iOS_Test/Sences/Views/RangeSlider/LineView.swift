//
//  Border.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 20/5/22.
//

import UIKit

class LineView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configeView()
    }
    
    func configeView() {
        self.backgroundColor =  UIColor(red: 119.0/255, green: 79.0/255, blue: 194.0/255, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
