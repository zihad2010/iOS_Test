//
//  ThumbCollViewCell.swift
//  iOS_Test
//
//  Created by Maya on 20/5/22.
//

import UIKit

class ThumbCollViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ThumbCollViewCell"
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var eachThumb: ThumbVm! {
        didSet{
            guard let thumb = eachThumb.name else { return }
            self.thumbImageView.image = UIImage(named: thumb.addString(".GIF"))
        }
    }
}