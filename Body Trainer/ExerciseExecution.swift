//
//  ExerciseExecution.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 13.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation

class ExerciseExecution  {
    enum ExecutionTypes {
        case ByIteration
        case ByTime
    }
    var name="Подход"
    var weight=Double(1) // kg
    var timeInterval=Int(60) // sec
    var timeIntervalRemain:String=""
    var timePassed:String="00:00:00"
    var iteration:Int?
    var executionType:ExecutionTypes
    var started=false
    var stopped=false
    var completed=false
    
    init(nameExecution:String, weightValue:Double, executionTypeValue:ExecutionTypes, timeValue:Int?, iterationValue:Int?) {
        name=nameExecution
        weight=weightValue
        if let valueTime=timeValue {
            timeInterval=valueTime
        }
        if let valueIteration=iterationValue {
            iteration=valueIteration
        }
        executionType=executionTypeValue
    }
    
    func resetTimeData() {
        timePassed="00:00:00"
    }

}
