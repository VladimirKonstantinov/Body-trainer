//
//  UIVideoTapGestureRecognizer.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 23.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class UIVideoTapGestureRecognizer: UITapGestureRecognizer {
    
    var controller:AnyObject!
    var videoPath:String!
    
    init(withVideoPath path:String, forController _controller:AnyObject, withSelector selector:Selector) {
        super.init(target: _controller, action: selector)
        videoPath=path
        controller=_controller
    }
    
    func showVideo(sender:UIVideoTapGestureRecognizer) {
        let avPlayer=AVPlayer(url: URL(fileURLWithPath: videoPath))
        let playerController = AVPlayerViewController()
        playerController.player = avPlayer
        (controller as! UIViewController).present(playerController, animated: true) {
            avPlayer.play()
        }
    }
    
}
