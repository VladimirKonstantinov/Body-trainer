//
//  vcImageFullscreen.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 15.04.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit
import Foundation

class vcImageFullscreen: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrFullscreenScrollView: UIScrollView!
    @IBOutlet weak var imgFullscreenImage: UIImageView!
    
    var img:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setingViewAfterLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setingViewAfterLoad() {
        scrFullscreenScrollView.delegate=self
        scrFullscreenScrollView.minimumZoomScale=1
        scrFullscreenScrollView.maximumZoomScale=6
        scrFullscreenScrollView.contentSize=imgFullscreenImage.frame.size
        imgFullscreenImage.contentMode = .scaleAspectFit
        imgFullscreenImage.backgroundColor = .black
        imgFullscreenImage.image=img
        imgFullscreenImage.isUserInteractionEnabled=true
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.longPressRecognizer))
        imgFullscreenImage.addGestureRecognizer(tap)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgFullscreenImage
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    // MARK: - Gestures
    
    
    /// Обработка жеста "Long press"
    ///
    /// - parameter longPress: Данные жеста
    func longPressRecognizer(longPress:UILongPressGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
   
    
}
