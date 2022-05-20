//
//  VideoHelper.swift
//  iOS_Test
//
//  Created by Maya on 20/5/22.
//

import UIKit
import AVFoundation

class ABVideoHelper: NSObject {

    static func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage{
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do{
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        }catch{
            
        }
        return UIImage()
    }
    
    static func videoDuration(videoURL: URL) -> Float64{
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }
    
}
