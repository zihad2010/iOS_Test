//
//  VideoTrimVCExt.swift
//  iOS_Test
//
//  Created by Maya on 21/5/22.
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
          print("Video saved.")
        } else {
          print("Cannot save video.")
          print(error ?? "unknown error")
        }
      }
    }
}
