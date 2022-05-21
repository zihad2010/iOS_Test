//
//  VideoPlayerView.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import UIKit
import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
    public var currentProgress: ((Float64) -> Void)? = nil
    
    private var periodicTimeObserver:Any?
    
    public enum Repeat {
        case once
        case loop
    }
    
    public var `repeat`: Repeat = .once
    
    override open class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    private var player: AVPlayer? {
        get {
            self.playerLayer.player
        }
        set {
            self.playerLayer.player = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var url: URL? {
        didSet {
            guard let url = self.url else {
                self.teardown()
                return
            }
            self.setup(url: url)
        }
    }
    
    private func setup(url: URL) {
        
        self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
        self.playerLayer.videoGravity = .resizeAspect
        self.addPreriodicTimeObsever()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemDidPlayToEndTime(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: self.player?.currentItem)
        
    }
    
    func addPreriodicTimeObsever() {
        
        if let periodicTimeObserver = self.periodicTimeObserver {
            self.player?.removeTimeObserver(periodicTimeObserver)
            self.periodicTimeObserver = nil
        }
        
        periodicTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1), timescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
            self?.currentProgress?(CMTimeGetSeconds(progressTime))
            print("periodic time: \(CMTimeGetSeconds(progressTime))")
        }
    }
    
    @objc func itemDidPlayToEndTime(_ notification: NSNotification) {
        guard self.repeat == .loop else {
            return
        }
        self.player?.seek(to: .zero)
        self.player?.play()
    }
    
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func itemFailedToPlayToEndTime(_ notification: NSNotification) {
        self.teardown()
    }
    
    deinit{
        teardown()
    }
    
    private func teardown() {
        self.player?.pause()
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: self.player?.currentItem)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemFailedToPlayToEndTime,
                                                  object: self.player?.currentItem)
        
        self.player = nil
    }
}

extension VideoView {
    
    public func updateVideoPlayerSeek(position: Float64){
        let selectedTime: CMTime = CMTimeMake(value: Int64(position * 1000 as Float64), timescale: 1000)
        self.player?.seek(to: selectedTime)
    }
}
