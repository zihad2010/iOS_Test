//
//  ViewController.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import UIKit

class HomeVC: UIViewController {
    
    public var coordinator: HomeCoordinator?
    private var videoPicker: VideoPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickVideoFromGalleryBttnPressed(_ sender: UIButton) {
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
    }
}

extension HomeVC: VideoPickerDelegate {
    
    func didSelect(url: URL?) {
        
        guard let url = url else {
            return
        }
        self.coordinator?.navigateToVideoTrimVCWith(videoUrl: url)
    }
}



