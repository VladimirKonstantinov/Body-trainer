//
//  timerCountdown.swift
//  test
//
//  Created by Vladimir Konstantinov on 22.01.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit
import Foundation

class TimerCountdown: NSObject {
    enum TimerStatus {
        case Start
        case Pause
    }
    var timer:Timer!
    var status:TimerStatus!
    var startedTime:Date!
    var itemStartedTime:Date!
    var beginTimerInterval:Int!
    var remainTimerInterval:Int!
    var passedTimerInterval=0
    var label:UILabel!
    var ownerIndex:Int!
    var ownerParent:Exercise!
    var delegate:TimerCountDownProtocol!
    
    
    init(withInterval interval:Int, forOwnerParent Parent:Exercise, forLabel textLabel:UILabel, forIndex index:Int, withDelegate delegateItem:TimerCountDownProtocol) {
        super.init()
        status = .Start
        beginTimerInterval=interval
        remainTimerInterval=interval
        label=textLabel
        ownerIndex=index
        ownerParent=Parent
        delegate=delegateItem
        activateTimer()
        let stringPassedItemsTotalTime=getItemsTotalTimerPassedString()
        ownerParent.strItemsTotalPassedTime=stringPassedItemsTotalTime
        let item=ownerParent.exerciseExecutions[ownerIndex]
        switch item {
        case is ExerciseExecution:
            if (item as! ExerciseExecution).executionType == .ByTime {
            (item as! ExerciseExecution).timeIntervalRemain=getTimerRemainString()
            }
            (item as! ExerciseExecution).timePassed=getTimerPassedString()
        case is ExerciseTimebreak:
            (item as! ExerciseTimebreak).timeIntervalRemain=getTimerRemainString()
            (item as! ExerciseTimebreak).timePassed=getTimerPassedString()
        default: break
        }
        delegate.TimerCountDownStep()
    }
    
    func stop() {
        if status == .Start {
        let itemsTotalPassedDelta=getItemsTotalTimerDelta()
        ownerParent.passedItemsTotalTimerInterval = itemsTotalPassedDelta.hour!*60*60+itemsTotalPassedDelta.minute!*60+itemsTotalPassedDelta.second!
        }
        timer.invalidate()
        delegate.TimerCountDownComplete(itemIndex: self.ownerIndex)
    }
    
    func activateTimer() {
        itemStartedTime=Date.init(timeInterval: TimeInterval(-passedTimerInterval), since: Date.init())
        ownerParent.itemStartedTime=Date.init(timeInterval: TimeInterval(-ownerParent.passedItemsTotalTimerInterval), since: Date.init())
        startedTime=Date.init(timeInterval: TimeInterval(remainTimerInterval), since: Date.init())
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerCountdown.timerStep), userInfo: nil, repeats: true)
    }
    
    func getTimerDelta(forPassed:Bool)->DateComponents {
        let calendar=Calendar.current
        if !forPassed {
            let timerCount=Date.init(timeInterval: -1, since: Date())
        return calendar.dateComponents(Set([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: timerCount, to: self.startedTime)
        }
        else {
            let timerCount=Date.init()
            return calendar.dateComponents(Set([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: self.itemStartedTime, to: timerCount)
        }
    }
    
    func getItemsTotalTimerDelta()->DateComponents {
        let timerCount=Date.init()
        let calendar=Calendar.current
        let maxExerciseTime=ownerParent.maxItemsTotalPassedTime
        if  (maxExerciseTime != nil) && timerCount>maxExerciseTime! {
            return calendar.dateComponents(Set([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: ownerParent.itemStartedTime, to: maxExerciseTime!)
        }
        else {
        return calendar.dateComponents(Set([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: ownerParent.itemStartedTime, to: timerCount)
        }
    }

    func getTimerRemainString()->String {
        var dateTime:Date
        let deltaComponents=getTimerDelta(forPassed: false)
        let timeFormatter=DateFormatter()
        timeFormatter.locale=NSLocale.current
        timeFormatter.dateFormat = "HH:mm:ss"
        if (deltaComponents.hour!<=0) && (deltaComponents.minute!<=0) && (deltaComponents.second!<=0) {
            return ""
        }
        dateTime=timeFormatter.date(from: "\(deltaComponents.hour!):\(deltaComponents.minute!):\(deltaComponents.second!)")!
        return timeFormatter.string(from: dateTime)
    }
    
    func getTimerPassedString()->String {
        let deltaComponents=getTimerDelta(forPassed: true)
        var dateTime:Date
        let timeFormatter=DateFormatter()
        timeFormatter.locale=NSLocale.current
        timeFormatter.dateFormat = "HH:mm:ss"
        if (deltaComponents.hour!*60*60+deltaComponents.minute!*60+deltaComponents.second!)>=beginTimerInterval {
            return getTimerStringFromInterval(beginTimerInterval)
        }
        dateTime=timeFormatter.date(from: "\(deltaComponents.hour!):\(deltaComponents.minute!):\(deltaComponents.second!)")!
        return timeFormatter.string(from: dateTime)
    }

    func getItemsTotalTimerPassedString()->String {
        let deltaComponents=getItemsTotalTimerDelta()
        var dateTime:Date
        let timeFormatter=DateFormatter()
        timeFormatter.locale=NSLocale.current
        timeFormatter.dateFormat = "HH:mm:ss"
//        if (deltaComponents.hour!*60*60+deltaComponents.minute!*60+deltaComponents.second!)>=beginTimerInterval {
//            return getTimerStringFromInterval(beginTimerInterval)
//        }
        dateTime=timeFormatter.date(from: "\(deltaComponents.hour!):\(deltaComponents.minute!):\(deltaComponents.second!)")!
        return timeFormatter.string(from: dateTime)
    }
    
    func timerStep() {
        let stringRemainTime=getTimerRemainString()
        let stringPassedTime=getTimerPassedString()
        let stringPassedItemsTotalTime=getItemsTotalTimerPassedString()
        ownerParent.strItemsTotalPassedTime=stringPassedItemsTotalTime
         if stringRemainTime=="" {
            let item=ownerParent.exerciseExecutions[ownerIndex]
            switch item {
            case is ExerciseExecution:
                (item as! ExerciseExecution).timePassed=stringPassedTime
            case is ExerciseTimebreak:
                (item as! ExerciseTimebreak).timePassed=stringPassedTime
            default: break
            }
            stop()
        }
        if timer.isValid {
            let item=ownerParent.exerciseExecutions[ownerIndex]
            switch item {
            case is ExerciseExecution:
                (item as! ExerciseExecution).timeIntervalRemain=stringRemainTime
                (item as! ExerciseExecution).timePassed=stringPassedTime
            case is ExerciseTimebreak:
                (item as! ExerciseTimebreak).timeIntervalRemain=stringRemainTime
                (item as! ExerciseTimebreak).timePassed=stringPassedTime
            default: break
            }
            delegate.TimerCountDownStep()
        }
    }
    
    func pause() {
        self.timer.invalidate()
        self.status = .Pause
        let delta=getTimerDelta(forPassed: false)
        self.remainTimerInterval = delta.hour!*60*60+delta.minute!*60+delta.second!
        let passedDelta=getTimerDelta(forPassed: true)
        self.passedTimerInterval = passedDelta.hour!*60*60+passedDelta.minute!*60+passedDelta.second!
        let itemsTotalPassedDelta=getItemsTotalTimerDelta()
        ownerParent.passedItemsTotalTimerInterval = itemsTotalPassedDelta.hour!*60*60+itemsTotalPassedDelta.minute!*60+itemsTotalPassedDelta.second!
        delegate.TimerCountDownPaused(itemIndex: self.ownerIndex)
    }
    
    func resume() {
        status = .Start
        activateTimer()
        timerStep()
        delegate.TimerCountDownResumed(itemIndex: self.ownerIndex)
    }
        
}
