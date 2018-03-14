//
//  UIImageFullscreenTapGestureRecognizer.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 16.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit

class UIImageFullscreenTapGestureRecognizer: UITapGestureRecognizer {
    
    var controller:AnyObject!
    var image:UIImage!
    var dissmissSelector:Selector!
    
    init(withImage img:UIImage, forController _controller:AnyObject, withSelector selector:Selector, andDissmissSelector selectorForDissmiss:Selector) {
        super.init(target: _controller, action: selector)
        image=img
        controller=_controller
        dissmissSelector=selectorForDissmiss
    }
        
    func showFullscreenImage(sender:UIImageFullscreenTapGestureRecognizer) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = (controller.view.superview?.superview?.frame)!
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleToFill
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: controller, action:dissmissSelector)
        newImageView.addGestureRecognizer(tap)
        controller.view.addSubview(newImageView)
    }
    
}
