//
//  VideoTrimVC.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import UIKit
import AVKit
import AVFoundation

class VideoTrimVC: UIViewController {
    
    @IBOutlet weak var gifViewBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var gipViewTrailConstant: NSLayoutConstraint!
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var giferView: UIImageView!
    @IBOutlet weak var gifthumbsCollectionView: UICollectionView!
    @IBOutlet var videoRangeSlider: VideoRangeSlider!
    @IBOutlet weak var startIndicatorLebel: UILabel!
    @IBOutlet weak var endIndicatorLebel: UILabel!
    @IBOutlet weak var exportButton: ExportButton!
    
    private let activity = ActivityIndicator()
    public var coordinator: VideoTrimCoordinator?
    public var url: URL?
    private(set) var thumbnailDataSource: CollectionViewDataSource<ThumbCollViewCell,ThumbVm>!
    private(set) var thumbs : [ThumbVm] = [ThumbVm]()
    private let editor = VideoEditor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpBinding()
        self.thumbsList()
        self.setUpView()
    }
    
    private func setUpView(){
        guard let url = self.url else {
            return
        }
        self.videoView.url = url
        self.showTrimView(url: url)
    }
    
    private func showTrimView(url: URL){
        
        videoRangeSlider.videoURL = url
        videoRangeSlider.delegate = self
        self.endIndicatorLebel.text = videoRangeSlider.duration.float64ToString().addString(UNIT)
        self.exportButton.endingPoint = videoRangeSlider.duration
    }
    
    //MARK: - setUpBinding -
    
    private func setUpBinding(){
        
        self.showThumbCollectionView()
        
        self.playPauseButton.action = { [weak self] isPlay in
            self?.videoisPlay(isPlay: isPlay)
            self?.videoView.repeat = .loop
        }
        
        self.videoView.currentProgress = { [weak self] currentProgress in
            self?.videoRangeSlider.updateProgressIndicator(seconds: currentProgress)
        }
    }
    
    private func videoisPlay(isPlay: Bool){
        isPlay ? self.videoView.play() : self.videoView.pause()
        self.playPauseButton?.update(isPlay: isPlay)
    }
    
    //MARK: - IBAction -
    
    @IBAction func cancelTrimingBttnPressed(_ sender: UIButton) {
        self.coordinator?.popViewController()
    }
    
    @IBAction func exportVideoBttonPressed(_ sender: ExportButton) {
        
        guard let startTime = sender.startingPoint, let endTime = sender.endingPoint,let videeoUrl = self.url else {
            return
        }
        self.videoisPlay(isPlay: false)
        self.activity.showLoading(view: self.view)
        self.editor.editVideoWith(videoURL: videeoUrl, startTime: startTime, endTime: endTime, gifName: exportButton.selectedGif) { [weak self] exportedURL in
            self?.saveVideoButtonTapped(videoUrl: exportedURL!)
            self?.activity.hideLoading()
        }
    }
    
    deinit{
        print("deinit-VideoTrimVC")
    }
}

// MARK: - VideoRangeSlider Delegate - Returns time in seconds-

extension VideoTrimVC: VideoRangeSliderDelegate{
    
    func didChangeValue(videoRangeSlider: VideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.exportButton.startingPoint = startTime
        self.exportButton.endingPoint = endTime
        self.startIndicatorLebel.text = startTime.float64ToString().addString(UNIT)
        self.endIndicatorLebel.text = endTime.float64ToString().addString(UNIT)
    }
    
    func indicatorDidChangePosition(videoRangeSlider: VideoRangeSlider, position: Float64) {
        self.videoView.updateVideoPlayerSeek(position: position)
        self.startIndicatorLebel.text = position.float64ToString().addString(UNIT)
    }
}


//MARK: - show collection of gif thumbs -

extension VideoTrimVC: UICollectionViewDelegate {
    
    private func thumbsList(){
        for i in 1...6 {
            self.thumbs.append(ThumbVm(name: "sticker".addString(i.intToString())))
        }
        thumbnailDataSource.updateItems(self.thumbs)
    }
    
    private func showThumbCollectionView(){
        
        self.gifthumbsCollectionView.collectionViewLayout = thumbCollectionViewLayout()
        self.thumbnailDataSource = CollectionViewDataSource(cellIdentifier: ThumbCollViewCell.cellIdentifier, items: self.thumbs, configureCell: { (cell, vm) in
            
            cell.eachThumb = vm
        })
        self.gifthumbsCollectionView.dataSource = self.thumbnailDataSource
    }
    
    private func thumbCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80.0, height:80.0)
        layout.minimumLineSpacing = 10
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let gifName = self.thumbs[indexPath.row].name else { return  }
        self.exportButton.selectedGif = gifName
        self.giferView.loadGif(asset: gifName)
    }
}



