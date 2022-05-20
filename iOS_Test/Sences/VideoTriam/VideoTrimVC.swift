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
    @IBOutlet weak var gifthumbsCollectionView: UICollectionView!
    @IBOutlet var videoRangeSlider: ABVideoRangeSlider!
    @IBOutlet weak var startIndicatorLebel: UILabel!
    @IBOutlet weak var endIndicatorLebel: UILabel!
    
    
    
    public var coordinator: VideoTrimCoordinator?
    public var url: URL?
    private(set) var thumbnailDataSource: CollectionViewDataSource<ThumbCollViewCell,ThumbVm>!
    private(set) var thumbs : [ThumbVm] = [ThumbVm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = self.url else {
            return
        }
        self.videoView.url = url
        self.setUpBinding()
        self.thumbsList()
        self.showTrimView()
    }
    
    private func showTrimView(){
        
        guard let url = self.url else {
            return
        }
        videoRangeSlider.setVideoURL(videoURL:url)
        
        videoRangeSlider.delegate = self
        videoRangeSlider.minSpace = 1.0
        //videoRangeSlider.maxSpace = 180.0
        
        //   lblMinSpace.text = "\(videoRangeSlider.minSpace)"
        
        videoRangeSlider.setStartPosition(seconds: 0.0)
        self.startIndicatorLebel.text = STARTVALUE.addString(UNIT)
        
        videoRangeSlider.setEndPosition(seconds: 5.0)
        self.endIndicatorLebel.text = ENDVALUE.addString(UNIT)
        
        // videoRangeSlider.startTimeView.marginLeft = 5.0
        // videoRangeSlider.startTimeView.marginRight = 5.0
        videoRangeSlider.startTimeView.timeLabel.textColor = .white
    }
    
    private func setUpBinding(){
        self.showThumbCollectionView()
        self.playPauseButton.action = { [weak self] isPlay in
            print(isPlay)
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

extension VideoTrimVC: ABVideoRangeSliderDelegate{
    
    // MARK: ABVideoRangeSlider Delegate - Returns time in seconds
    
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.startIndicatorLebel.text = startTime.float64ToString().addString(UNIT)
        self.endIndicatorLebel.text = endTime.float64ToString().addString(UNIT)
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        print("position of indicator: \(position)")
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
        self.giferView.loadGif(asset: gifName)
    }
}



