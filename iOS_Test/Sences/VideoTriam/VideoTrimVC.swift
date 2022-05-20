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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
//MARK: - show collection of gif -
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
            print("vm:",vm)
            cell.thumbImageView.image = UIImage(named: (vm.name?.addString(".GIF"))!)
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



