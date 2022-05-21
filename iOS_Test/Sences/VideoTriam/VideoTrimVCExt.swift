//
//  VideoTrimVCExt.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 21/5/22.
//

import UIKit
import AVKit
import Photos

extension VideoTrimVC {
    
    func saveVideoButtonTapped(videoUrl: URL) {
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                self?.saveVideoToPhotos(videoUrl: videoUrl)
            default:
                print("Photos permissions not granted.")
                return
            }
        }
    }
    
    private func saveVideoToPhotos(videoUrl: URL) {
        
        PHPhotoLibrary.shared().performChanges( {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { [weak self] (isSaved, error) in
            if isSaved {
                self?.showAleart(mess: "Video was successfully saved.")
            } else {
                self?.showAleart(mess: "Cannot save video.!")
            }
        }
    }
    
    private func showAleart(mess: String){
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: mess, message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
