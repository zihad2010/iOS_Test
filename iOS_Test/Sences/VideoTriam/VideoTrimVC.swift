//
//  VideoTrimVC.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import UIKit

class VideoTrimVC: UIViewController {
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var giferView: UIImageView!
    @IBOutlet weak var gifthumbsCollectionView: UICollectionView!
    @IBOutlet var videoRangeSlider: VideoRangeSlider!
    @IBOutlet weak var startIndicatorLebel: UILabel!
    @IBOutlet weak var endIndicatorLebel: UILabel!
    @IBOutlet weak var exportButton: ExportButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var coordinator: VideoTrimCoordinator?
    public var url: URL?
    private(set) var thumbnailDataSource: CollectionViewDataSource<ThumbCollViewCell,ThumbVm>!
    private(set) var thumbs : [ThumbVm] = [ThumbVm]()
    private let editor = VideoEditor()

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
        videoRangeSlider.setStartPosition(seconds: 0.0)
        self.startIndicatorLebel.text = STARTVALUE.addString(UNIT)
        self.endIndicatorLebel.text = videoRangeSlider.duration.float64ToString().addString(UNIT)
        self.exportButton.endingPoint = videoRangeSlider.duration
    }
    
    //MARK: - setUpBinding -
    
    private func setUpBinding(){
       
        self.showThumbCollectionView()
       
        self.playPauseButton.action = { [weak self] isPlay in
            print(isPlay)
            isPlay ? self?.videoView.play() : self?.videoView.pause()
            self?.playPauseButton?.update(isPlay: isPlay)
        }
        
        self.videoView.currentProgress = { [weak self] currentProgress in
            self?.videoRangeSlider.updateProgressIndicator(seconds: currentProgress)
        }
    }
    
    //MARK: - IBAction -
    
    @IBAction func cancelTrimingBttnPressed(_ sender: UIButton) {
        self.coordinator?.popViewController()
    }
    
    @IBAction func exportVideoBttonPressed(_ sender: ExportButton) {
        
        guard let startTime = sender.startingPoint, let endTime = sender.endingPoint,let videeoUrl = self.url else {
            return
        }
        self.activityIndicator.startAnimating()
        self.editor.editVideoWith(videoURL: videeoUrl, startTime: startTime, endTime: endTime, gifName: exportButton.selectedGif) { [weak self] exportedURL in
            self?.saveVideoButtonTapped(videoUrl: exportedURL!)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    deinit{
        print("deinit-VideoTrimVC")
    }
    
}

extension VideoTrimVC: VideoRangeSliderDelegate{
    
    // MARK: VideoRangeSlider Delegate - Returns time in seconds
    
    func didChangeValue(videoRangeSlider: VideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.exportButton.startingPoint = startTime
        self.exportButton.endingPoint = endTime
        self.startIndicatorLebel.text = startTime.float64ToString().addString(UNIT)
        self.endIndicatorLebel.text = endTime.float64ToString().addString(UNIT)
    }
    
    func indicatorDidChangePosition(videoRangeSlider: VideoRangeSlider, position: Float64) {
        self.videoView.updateVideoPlayerSeek(position: position)
        self.startIndicatorLebel.text = position.float64ToString().addString(UNIT)
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
        self.exportButton.selectedGif = gifName
        self.giferView.loadGif(asset: gifName)
    }
}



