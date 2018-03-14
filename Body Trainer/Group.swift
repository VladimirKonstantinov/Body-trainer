//
//  TopGroup.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 28.09.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit


class Group {
    var name: String!
    var img: UIImage?
    var areas: [Area]!
    var isOpen:Bool
    var lastActivity:Date?
    init(nameGroup:String) {
        name=nameGroup
        isOpen=true
        areas=[Area]()
    }
}
