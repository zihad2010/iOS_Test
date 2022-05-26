//
//  AVAssetExt.swift
//  iOS_Test
//
//  Created by Maya on 26/5/22.
//

import AVKit
import AVFoundation

extension AVAsset {
    func videoSize()->CGSize{
        let tracks = self.tracks(withMediaType: AVMediaType.video)
        if (tracks.count > 0){
            let videoTrack = tracks[0]
            let size = videoTrack.naturalSize
            let txf = videoTrack.preferredTransform
            let realVidSize = size.applying(txf)
            return realVidSize
        }
        return CGSize(width: 0, height: 0)
    }
    
}
