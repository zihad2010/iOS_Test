//
//  VideoTrimVC.swift
//  iOS_Test
//
//  Created by Maya on 19/5/22.
//

import UIKit

class VideoTrimVC: UIViewController {
    
    var coordinator: VideoTrimCoordinator?
    var videoPicker: VideoPicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func pickVideoFromGalleryBttnPressed(_ sender: UIButton) {
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
      //  self.videoPicker.present(from: sender)
    }
    
    @IBAction func cancelTrimingBttnPressed(_ sender: UIButton) {
        self.coordinator?.popViewController()
    }

}

extension VideoTrimVC: VideoPickerDelegate {

    func didSelect(url: URL?) {
        guard let url = url else {
            return
        }
        print(url)
        //self.videoView.url = url
        //self.videoView.player?.play()
    }
}



