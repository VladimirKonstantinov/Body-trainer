//
//  Area.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 29.09.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit

class Area {
    var name:String!
    var parent:Group!
    var img:UIImage?
    var isOpen:Bool
    var lastActivity:Date? {
        didSet {
            if (parent != nil) {
            parent.lastActivity=lastActivity
            }
        }
    }

    var exercises:[Exercise]!
    init(nameArea:String) {
        name=nameArea
        isOpen=true
        exercises=[Exercise]()
    }
}
