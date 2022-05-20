//
//  VideoPlayerView.swift
//  iOS_Test
//
//  Created by Maya on 19/5/22.
//

import UIKit
import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemDidPlayToEndTime(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: self.player?.currentItem)
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











/*open class VideoPlayer: UIView {
    
    public enum Repeat {
        case once
        case loop
    }
    
    override open class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    public var player: AVPlayer? {
        get {
            self.playerLayer.player
        }
        set {
            self.playerLayer.player = newValue
        }
    }
    
    open override var contentMode: UIView.ContentMode {
        didSet {
            switch self.contentMode {
            case .scaleAspectFit:
                self.playerLayer.videoGravity = .resizeAspect
            case .scaleAspectFill:
                self.playerLayer.videoGravity = .resizeAspectFill
            default:
                self.playerLayer.videoGravity = .resize
            }
        }
    }
    
    public var `repeat`: Repeat = .once
    
    public var url: URL? {
        didSet {
            guard let url = self.url else {
                self.teardown()
                return
            }
            self.setup(url: url)
        }
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    public init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initialize()
    }
    
    open func initialize() {
        
    }
    
    deinit {
        self.teardown()
    }
    
    
    private func setup(url: URL) {
        
        self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
        
        self.player?.currentItem?.addObserver(self,
                                              forKeyPath: "status",
                                              options: [.old, .new],
                                              context: nil)
        
        self.player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemDidPlayToEndTime(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: self.player?.currentItem)
    }
    
    private func teardown() {
        self.player?.pause()
        
        self.player?.currentItem?.removeObserver(self, forKeyPath: "status")
        
        self.player?.removeObserver(self, forKeyPath: "rate")
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: self.player?.currentItem)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemFailedToPlayToEndTime,
                                                  object: self.player?.currentItem)
        
        self.player = nil
    }
    
    @objc func itemDidPlayToEndTime(_ notification: NSNotification) {
        guard self.repeat == .loop else {
            return
        }
        self.player?.seek(to: .zero)
        self.player?.play()
    }
    
    @objc func itemFailedToPlayToEndTime(_ notification: NSNotification) {
        self.teardown()
    }
    
    
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let status = self.player?.currentItem?.status, status == .failed {
            self.teardown()
        }
        
        if
            keyPath == "rate",
            let player = self.player,
            player.rate == 0,
            let item = player.currentItem,
            !item.isPlaybackBufferEmpty,
            CMTimeGetSeconds(item.duration) != CMTimeGetSeconds(player.currentTime())
        {
            self.player?.play()
        }
    }
}*/

