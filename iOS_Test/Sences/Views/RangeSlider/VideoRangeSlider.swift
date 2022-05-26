//
//  VideoRangeSlider.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 20/5/22.
//

import Foundation

import UIKit

protocol VideoRangeSliderDelegate: AnyObject {
    func didChangeValue(videoRangeSlider: VideoRangeSlider, startTime: Float64, endTime: Float64)
    func indicatorDidChangePosition(videoRangeSlider: VideoRangeSlider, position: Float64)
}

public class VideoRangeSlider: UIView {
    
    private enum DragHandleChoice {
        case start
        case end
    }
    
    weak var delegate: VideoRangeSliderDelegate?
    
    private var startIndicator      = StartIndicatorView()
    private var endIndicator        = EndIndicatorView()
    private var topLine             = LineView()
    private var bottomLine          = LineView()
    private var progressIndicator   = ProgressIndicatorView()
    
    let thumbnailsManager   = ThumbnailsManager()
    var duration: Float64   = 0.0
    var videoURL            = URL(fileURLWithPath: "")
    
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
        
        startIndicator = StartIndicatorView(frame: CGRect(x: 0,
                                                          y: -topBorderHeight,
                                                          width: 20,
                                                          height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        startIndicator.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        startIndicator.addGestureRecognizer(startDrag)
        self.addSubview(startIndicator)
        
        
        let endDrag = UIPanGestureRecognizer(target:self,
                                             action: #selector(endDragged(recognizer:)))
        
        endIndicator = EndIndicatorView(frame: CGRect(x: 0,
                                                      y: -topBorderHeight,
                                                      width: indicatorWidth,
                                                      height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        endIndicator.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        endIndicator.addGestureRecognizer(endDrag)
        self.addSubview(endIndicator)
        
        
        topLine = LineView(frame: CGRect(x: 0,
                                           y: -topBorderHeight,
                                           width: indicatorWidth,
                                           height: topBorderHeight))
        self.addSubview(topLine)
        
        bottomLine = LineView(frame: CGRect(x: 0,
                                              y: self.frame.size.height,
                                              width: indicatorWidth,
                                              height: bottomBorderHeight))
        self.addSubview(bottomLine)
        
        let progressDrag = UIPanGestureRecognizer(target:self,
                                                  action: #selector(progressDragged(recognizer:)))
        
        progressIndicator = ProgressIndicatorView(frame: CGRect(x: 0,
                                                                y: -topBorderHeight,
                                                                width: 10,
                                                                height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        progressIndicator.addGestureRecognizer(progressDrag)
        self.addSubview(progressIndicator)
    }
    
    // MARK: Public functions
    
    public func updateProgressIndicator(seconds: Float64){
        let endSeconds = secondsFromValue(value: self.endPercentage)
        
        if seconds >= endSeconds {
            self.resetProgressPosition()
        } else {
            self.progressPercentage = self.valueFromSeconds(seconds: Float(seconds))
        }
        layoutSubviews()
    }
    
    public func setVideoURL(videoURL: URL){
        self.duration = VideoHelper.videoDuration(videoURL: videoURL)
        self.videoURL = videoURL
        self.superview?.layoutSubviews()
        self.updateThumbnails()
    }
    
    public func updateThumbnails(){
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        backgroundQueue.async {
            _ = self.thumbnailsManager.updateThumbnails(view: self, videoURL: self.videoURL, duration: self.duration)
        }
    }
    
    // MARK: - Crop Handle Drag Functions
    
    @objc private func startDragged(recognizer: UIPanGestureRecognizer){
        self.processHandleDrag(
            recognizer: recognizer,
            drag: .start,
            currentPositionPercentage: self.startPercentage,
            currentIndicator: self.startIndicator
        )
    }
    
    @objc private func endDragged(recognizer: UIPanGestureRecognizer){
        self.processHandleDrag(
            recognizer: recognizer,
            drag: .end,
            currentPositionPercentage: self.endPercentage,
            currentIndicator: self.endIndicator
        )
    }
    
    private func processHandleDrag(
        recognizer: UIPanGestureRecognizer,
        drag: DragHandleChoice,
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
        
        progressIndicator.center = CGPoint(x: progressPosition , y: progressIndicator.center.y)
        let progressPercentage = progressIndicator.center.x * 100 / self.frame.width
        
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
        
        progressIndicator.center = CGPoint(x: position , y: progressIndicator.center.y)
        
        let percentage = progressIndicator.center.x * 100 / self.frame.width
        
        let progressSeconds = secondsFromValue(value: progressPercentage)
        
        self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: progressSeconds)
        
        self.progressPercentage = percentage
        
        layoutSubviews()
    }
    
    // MARK: - Drag Functions Helpers
    private func positionFromValue(value: CGFloat) -> CGFloat{
        let position = value * self.frame.size.width / 100
        return position
    }
    
    private func getPositionLimits(with drag: DragHandleChoice) -> (min: CGFloat, max: CGFloat) {
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
    
    private func checkEdgeCasesForPosition(with position: CGFloat, and positionLimit: CGFloat, and drag: DragHandleChoice) -> CGFloat {
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
        progressIndicator.center = CGPoint(x: progressPosition , y: progressIndicator.center.y)
        
        let startSeconds = secondsFromValue(value: self.progressPercentage)
        self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: startSeconds)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let startPosition = positionFromValue(value: self.startPercentage)
        let endPosition = positionFromValue(value: self.endPercentage)
        let progressPosition = positionFromValue(value: self.progressPercentage)
        
        startIndicator.center = CGPoint(x: startPosition, y: startIndicator.center.y)
        endIndicator.center = CGPoint(x: endPosition, y: endIndicator.center.y)
        progressIndicator.center = CGPoint(x: progressPosition, y: progressIndicator.center.y)
        
        
        topLine.frame = CGRect(x: startIndicator.frame.origin.x + startIndicator.frame.width,
                               y: -topBorderHeight,
                               width: endIndicator.frame.origin.x - startIndicator.frame.origin.x - endIndicator.frame.size.width,
                               height: topBorderHeight)
        
        bottomLine.frame = CGRect(x: startIndicator.frame.origin.x + startIndicator.frame.width,
                                  y: self.frame.size.height,
                                  width: endIndicator.frame.origin.x - startIndicator.frame.origin.x - endIndicator.frame.size.width,
                                  height: bottomBorderHeight)
        
    }
    
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds = CGRect(x: -startIndicator.frame.size.width,
                                    y: -topLine.frame.size.height,
                                    width: self.frame.size.width + startIndicator.frame.size.width + endIndicator.frame.size.width,
                                    height: self.frame.size.height + topLine.frame.size.height + bottomLine.frame.size.height)
        return extendedBounds.contains(point)
    }
    
}
