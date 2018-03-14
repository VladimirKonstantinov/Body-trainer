//
//  ExerciseTimebreak.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 13.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation

class ExerciseTimebreak  {
    var name="Перерыв"
    var timeInterval=Int(60) // sec
    var timeIntervalRemain:String=""
    var timePassed:String="00:00:00"
    var started=false
    var completed=false
    init(){}
    init(time:Int) {
        timeInterval=time
    }
    init(nameTimebreak:String, time:Int) {
        name=nameTimebreak
        timeInterval=time
    }
    func resetTimeData() {
    timePassed="00:00:00"
    }
}
