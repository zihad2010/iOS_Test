//
//  PlayPauseButton.swift
//  iOS_Test
//
//  Created by Maya on 19/5/22.
//

import UIKit

class PlayPauseButton: UIButton {
    
    let play = UIImage(named: "play")
    let pause = UIImage(named: "pause")
    var action: ((Bool) -> Void)? = nil
    
    private(set) var isPlay: Bool = false {
        didSet{
            self.setImage(
                self.isPlay ? self.pause : self.play,
                for: .normal
            )
        }
    }
    
    deinit{
        print("deinit-PlayPauseButton")
    }
    override func awakeFromNib() {
        self.addTarget(
            self,
            action:#selector(buttonClicked(sender:)),
            for: .touchUpInside
        )
        self.isPlay = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            self.action?(!self.isPlay)
        }
    }
    
    func update(isPlay: Bool) {
        self.isPlay = isPlay
    }
}
