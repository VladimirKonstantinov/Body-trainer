//
//  ImageManager.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 08.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/// Сохраняет выбранную фотографию в элемент массива
///
/// - parameter img:  Фотография
/// - parameter item: Элемент массива
func setSelectedImage(_ img:UIImage, toItem item:Any, completion: (() -> Swift.Void)? = nil) {
    switch item {
    case is Group:
        (item as! Group).img=img
    case is Area:
        (item as! Area).img=img
    case is Exercise:
        (item as! Exercise).img=img
    case is InformationImage:
        (item as! InformationImage).image=img
    default:
        return
    }
    if let completeParam=completion {
        completeParam()
    }
}

/// Сохраняет путь выбранного видео в элемент массива
///
/// - parameter img:  Фотография
/// - parameter item: Элемент массива
func setSelectedVideo(_ fromURL:NSURL, toItem item:Any, completion: (() -> Swift.Void)? = nil) {
    switch item {
    case is InformationVideo:
        let preview=getPreviewImageForVideoAtURL(fromURL)
        (item as! InformationVideo).path=fromURL.path!
        (item as! InformationVideo).previewImage=preview
        
    default:
        return
    }
    if let completeParam=completion {
        completeParam()
    }
}

func getPreviewImageForVideoAtURL(_ fromURL:NSURL)->UIImage? {
    let asset = AVURLAsset(url: fromURL as URL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    
    let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
    
    do {
        let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
        return UIImage(cgImage: imageRef)
    }
    catch
    {
        return nil
    }
}
