//
//  Exercise.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 29.09.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit

class Exercise {
    var name:String!
    var parent:Area!
    var img:UIImage?
    var timeStarted:Date?
    var strItemsTotalPassedTime="00:00:00"
    var maxItemsTotalPassedTime:Date?
    var passedItemsTotalTimerInterval=0
    var itemStartedTime:Date!
    
    var lastActivity:Date? {
        didSet {
            if (parent != nil) {
            parent.lastActivity=lastActivity
            }
        }
    }
    var exerciseExecutions:[Any]
    var exerciseInformation:[Any]
    init(nameExercise:String) {
        name=nameExercise
        exerciseExecutions=[Any]()
        exerciseInformation=[Any]()
    }
}
