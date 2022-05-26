//
//  VideoRangeSlider.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 20/5/22.
//

import Foundation
import AVFoundation
import UIKit

protocol VideoRangeSliderDelegate: AnyObject {
    func didChangeValue(videoRangeSlider: VideoRangeSlider, startTime: Float64, endTime: Float64)
    func indicatorDidChangePosition(videoRangeSlider: VideoRangeSlider, position: Float64)
}

public class VideoRangeSlider: UIView {
    
    weak var delegate: VideoRangeSliderDelegate?
    
    private var leftIndicatorView      = LeftIndicatorView()
    private var rightIndicatorView        = RightIndicatorView()
    private var topLineView            = LineView()
    private var bottomLineView          = LineView()
    private var seekBarView   = SeekBarView()
    
    private let thumbnailsManager   = ThumbsManager()
    
    public var duration: Float64   = 0.0
    
    public var videoURL            = URL(fileURLWithPath: ""){
        didSet{
            self.duration = self.videoDuration(videoURL: videoURL)
            self.superview?.layoutSubviews()
            self.showThumbnailsOnSlider()
        }
    }
    
    var progressPercentage: CGFloat = 0
    private var minSpace: Float = 1
    private var maxSpace: Float = 0
    private var startPercentage: CGFloat    = 0
    private var endPercentage: CGFloat      = 100
    
    private let topBorderHeight: CGFloat      = 5
    private  let bottomBorderHeight: CGFloat   = 5
    private let indicatorWidth: CGFloat = 20.0
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup(){
        self.isUserInteractionEnabled = true
        
        let startDrag = UIPanGestureRecognizer(target:self,
                                               action: #selector(startDragged(recognizer:)))
        
        leftIndicatorView = LeftIndicatorView(frame: CGRect(x: 0,
                                                          y: -topBorderHeight,
                                                          width: 20,
                                                          height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        leftIndicatorView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        leftIndicatorView.addGestureRecognizer(startDrag)
        self.addSubview(leftIndicatorView)
        
        
        let endDrag = UIPanGestureRecognizer(target:self,
                                             action: #selector(endDragged(recognizer:)))
        
        rightIndicatorView = RightIndicatorView(frame: CGRect(x: 0,
                                                      y: -topBorderHeight,
                                                      width: indicatorWidth,
                                                      height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        rightIndicatorView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        rightIndicatorView.addGestureRecognizer(endDrag)
        self.addSubview(rightIndicatorView)
        
        
        topLineView = LineView(frame: CGRect(x: 0,
                                         y: -topBorderHeight,
                                         width: indicatorWidth,
                                         height: topBorderHeight))
        self.addSubview(topLineView)
        
        bottomLineView = LineView(frame: CGRect(x: 0,
                                            y: self.frame.size.height,
                                            width: indicatorWidth,
                                            height: bottomBorderHeight))
        self.addSubview(bottomLineView)
        
        let progressDrag = UIPanGestureRecognizer(target:self,
                                                  action: #selector(progressDragged(recognizer:)))
        
        seekBarView = SeekBarView(frame: CGRect(x: 0,
                                                                y: -topBorderHeight,
                                                                width: 10,
                                                                height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        seekBarView.addGestureRecognizer(progressDrag)
        self.addSubview(seekBarView)
    }
        
    public func updateProgressIndicator(seconds: Float64){
        let endSeconds = secondsFromValue(value: self.endPercentage)
        
        if seconds >= endSeconds {
            self.resetProgressPosition()
        } else {
            self.progressPercentage = self.valueFromSeconds(seconds: Float(seconds))
        }
        layoutSubviews()
    }
    
    @objc private func startDragged(recognizer: UIPanGestureRecognizer){
        self.processHandleDrag(
            recognizer: recognizer,
            drag: .start,
            currentPositionPercentage: self.startPercentage,
            currentIndicator: self.leftIndicatorView
        )
    }
    
    @objc private func endDragged(recognizer: UIPanGestureRecognizer){
        self.processHandleDrag(
            recognizer: recognizer,
            drag: .end,
            currentPositionPercentage: self.endPercentage,
            currentIndicator: self.rightIndicatorView
        )
    }
    
    private func processHandleDrag(
        recognizer: UIPanGestureRecognizer,
        drag: DragType,
        currentPositionPercentage: CGFloat,
        currentIndicator: UIView
    ) {
        
        let translation = recognizer.translation(in: self)
        
        var position: CGFloat = positionFromValue(value: currentPositionPercentage)
        
        position = position + translation.x
        
        if position < 0 { position = 0 }
        
        if position > self.frame.size.width {
            position = self.frame.size.width
        }
        
        let positionLimits = getPositionLimits(with: drag)
        position = checkEdgeCasesForPosition(with: position, and: positionLimits.min, and: drag)
        
        if Float(self.duration) > self.maxSpace && self.maxSpace > 0 {
            if drag == .start {
                if position < positionLimits.max {
                    position = positionLimits.max
                }
            } else {
                if position > positionLimits.max {
                    position = positionLimits.max
                }
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self)
        
        currentIndicator.center = CGPoint(x: position , y: currentIndicator.center.y)
        
        let percentage = currentIndicator.center.x * 100 / self.frame.width
        
        let startSeconds = secondsFromValue(value: self.startPercentage)
        let endSeconds = secondsFromValue(value: self.endPercentage)
        
        self.delegate?.didChangeValue(videoRangeSlider: self, startTime: startSeconds, endTime: endSeconds)
        
        var progressPosition: CGFloat = 0.0
        
        if drag == .start {
            self.startPercentage = percentage
        } else {
            self.endPercentage = percentage
        }
        
        if drag == .start {
            progressPosition = positionFromValue(value: self.startPercentage)
            
        } else {
            if recognizer.state != .ended {
                progressPosition = positionFromValue(value: self.endPercentage)
            } else {
                progressPosition = positionFromValue(value: self.startPercentage)
            }
        }
        
        seekBarView.center = CGPoint(x: progressPosition , y: seekBarView.center.y)
        let progressPercentage = seekBarView.center.x * 100 / self.frame.width
        
        if self.progressPercentage != progressPercentage {
            let progressSeconds = secondsFromValue(value: progressPercentage)
            self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: progressSeconds)
        }
        
        self.progressPercentage = progressPercentage
        
        layoutSubviews()
    }
    
    @objc func progressDragged(recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self)
        
        let positionLimitStart  = positionFromValue(value: self.startPercentage)
        let positionLimitEnd    = positionFromValue(value: self.endPercentage)
        
        var position = positionFromValue(value: self.progressPercentage)
        position = position + translation.x
        
        if position < positionLimitStart {
            position = positionLimitStart
        }
        
        if position > positionLimitEnd {
            position = positionLimitEnd
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self)
        
        seekBarView.center = CGPoint(x: position , y: seekBarView.center.y)
        
        let percentage = seekBarView.center.x * 100 / self.frame.width
        
        let progressSeconds = secondsFromValue(value: progressPercentage)
        
        self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: progressSeconds)
        
        self.progressPercentage = percentage
        
        layoutSubviews()
    }
    

    private func positionFromValue(value: CGFloat) -> CGFloat{
        let position = value * self.frame.size.width / 100
        return position
    }
    
    private func getPositionLimits(with drag: DragType) -> (min: CGFloat, max: CGFloat) {
        if drag == .start {
            return (
                positionFromValue(value: self.endPercentage - valueFromSeconds(seconds: self.minSpace)),
                positionFromValue(value: self.endPercentage - valueFromSeconds(seconds: self.maxSpace))
            )
        } else {
            return (
                positionFromValue(value: self.startPercentage + valueFromSeconds(seconds: self.minSpace)),
                positionFromValue(value: self.startPercentage + valueFromSeconds(seconds: self.maxSpace))
            )
        }
    }
    
    private func checkEdgeCasesForPosition(with position: CGFloat, and positionLimit: CGFloat, and drag: DragType) -> CGFloat {
        if drag == .start {
            if Float(self.duration) < self.minSpace {
                return 0
            } else {
                if position > positionLimit {
                    return positionLimit
                }
            }
        } else {
            if Float(self.duration) < self.minSpace {
                return self.frame.size.width
            } else {
                if position < positionLimit {
                    return positionLimit
                }
            }
        }
        
        return position
    }
    
    private func secondsFromValue(value: CGFloat) -> Float64{
        return duration * Float64((value / 100))
    }
    
    private func valueFromSeconds(seconds: Float) -> CGFloat{
        return CGFloat(seconds * 100) / CGFloat(duration)
    }
    
    
    private func resetProgressPosition() {
        self.progressPercentage = self.startPercentage
        let progressPosition = positionFromValue(value: self.progressPercentage)
        seekBarView.center = CGPoint(x: progressPosition , y: seekBarView.center.y)
        
        let startSeconds = secondsFromValue(value: self.progressPercentage)
        self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: startSeconds)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let startPosition = positionFromValue(value: self.startPercentage)
        let endPosition = positionFromValue(value: self.endPercentage)
        let progressPosition = positionFromValue(value: self.progressPercentage)
        
        leftIndicatorView.center = CGPoint(x: startPosition, y: leftIndicatorView.center.y)
        rightIndicatorView.center = CGPoint(x: endPosition, y: rightIndicatorView.center.y)
        seekBarView.center = CGPoint(x: progressPosition, y: seekBarView.center.y)
        
        
        topLineView.frame = CGRect(x: leftIndicatorView.frame.origin.x + leftIndicatorView.frame.width,
                               y: -topBorderHeight,
                               width: rightIndicatorView.frame.origin.x - leftIndicatorView.frame.origin.x - rightIndicatorView.frame.size.width,
                               height: topBorderHeight)
        
        bottomLineView.frame = CGRect(x: leftIndicatorView.frame.origin.x + leftIndicatorView.frame.width,
                                  y: self.frame.size.height,
                                  width: rightIndicatorView.frame.origin.x - leftIndicatorView.frame.origin.x - rightIndicatorView.frame.size.width,
                                  height: bottomBorderHeight)
        
    }
    
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds = CGRect(x: -leftIndicatorView.frame.size.width,
                                    y: -topLineView.frame.size.height,
                                    width: self.frame.size.width + leftIndicatorView.frame.size.width + rightIndicatorView.frame.size.width,
                                    height: self.frame.size.height + topLineView.frame.size.height + bottomLineView.frame.size.height)
        return extendedBounds.contains(point)
    }
    
}

extension VideoRangeSlider {
    
    private func videoDuration(videoURL: URL) -> Float64{
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }
    
    private func showThumbnailsOnSlider(){
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        backgroundQueue.async {
            _ = self.thumbnailsManager.createThumbnailsFromVideo(view: self, videoURL: self.videoURL, duration: self.duration)
        }
    }
}

private enum DragType {
    case start
    case end
}


