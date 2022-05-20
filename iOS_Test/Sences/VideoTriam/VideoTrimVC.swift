//
//  VideoTrimVC.swift
//  iOS_Test
//
//  Created by Maya on 19/5/22.
//

import UIKit

class VideoTrimVC: UIViewController {
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var giferView: UIImageView!

    
    public var coordinator: VideoTrimCoordinator?
    public var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = self.url else {
            return
        }

    self.videoView.url = url
    self.setUpBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setUpBinding(){
        self.playPauseButton.action = { [weak self] isPlay in
            print(isPlay)
            self?.giferView.loadGif(asset: "sticker1")

            isPlay ? self?.videoView.play() : self?.videoView.pause()
            self?.playPauseButton?.update(isPlay: isPlay)
        }
    }
    
    @IBAction func cancelTrimingBttnPressed(_ sender: UIButton) {
        self.coordinator?.popViewController()
    }
    
    deinit{
        print("deinit-VideoTrimVC")
    }
    
}

extension VideoTrimVC {
    
}



