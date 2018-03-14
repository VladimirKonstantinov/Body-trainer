//
//  InformationVideoCollection.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 23.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class InformationVideo {
    var name="Видео"
    var previewImage:UIImage?
    var path:String? {
        didSet {
            duration=""
            if path != nil {
        let asset=AVAsset(url: URL(fileURLWithPath: path!))
        let sec=CMTimeGetSeconds(asset.duration)
                duration=getTimerStringFromInterval(Int(sec))
            }
        }
    }
    var duration:String?
    
    init () {}
    
}
