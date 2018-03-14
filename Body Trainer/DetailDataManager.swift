//
//  DetailDataManager.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 15.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Data managing

/// Добавляет перерыв
///
/// - parameter name: Наименование перерыва
/// - parameter interval: Длительность перерыва
/// - parameter exercise: Упражнение, для которого добавляется перерыв
///
/// - returns: Созданный перерыв
func addTimebreak(_ name:String?, _ interval:Int?, _ exercise:Exercise)->ExerciseTimebreak {
    var timebreak:ExerciseTimebreak
    let nameTimebreak=name
    let intervalTimebreak=interval
    switch (nameTimebreak, intervalTimebreak) {
    case (nil, nil):
        timebreak=ExerciseTimebreak.init()
    case (nil,_):
        timebreak=ExerciseTimebreak.init(time: intervalTimebreak!)
    default:
        timebreak=ExerciseTimebreak(nameTimebreak: name!,time: interval!)
    }
    exercise.exerciseExecutions.append(timebreak)
    return timebreak
    
}

/// Добавляет подход
///
/// - parameter name: Наименование подхода
/// - parameter weightValue: Вес подхода
/// - parameter executionTypeValue: Тип подхода
/// - parameter timeValue: Длительность подхода
/// - parameter iterationValue: Количество повторов в подходе
/// - parameter exercise: Упражнение, для которого добавляется подход
///
/// - returns: Созданный подход
func addExecution(_ name:String?, weightValue:Double, executionTypeValue:ExerciseExecution.ExecutionTypes, timeValue:Int?, iterationValue:Int?, _ exercise:Exercise)->ExerciseExecution {
    var execution:ExerciseExecution
    execution=ExerciseExecution(nameExecution: name!, weightValue:weightValue, executionTypeValue:executionTypeValue, timeValue: timeValue, iterationValue: iterationValue)
    exercise.exerciseExecutions.append(execution)
    return execution
    
}

/// Добавляет информацию: Текст
///
/// - parameter name: Наименование описания
/// - parameter description: Текст описания
/// - parameter exercise: Упражнение, для которого добавляется описание
///
/// - returns: Созданный элемент
func addTextInformation(withName name:String, andDescription description:String, forExercise exercise:Exercise)->InformationText {
    let textInformation=InformationText(name: name, withDescription: description)
    exercise.exerciseInformation.append(textInformation)
    return textInformation
    
}

/// Заменяет информацию: Текст
///
/// - parameter text: Изменяемый элемент
/// - parameter name: Наименование описания
/// - parameter description: Текст описания
func changeTextInformation(forText text:InformationText, withName name:String, andDescription description:String) {
    text.name=name
    text.textDescription=description
}


// MARK: - Timer managing


/// Активирует таймер перерыва в строке
///
/// - parameter indexPath: Индекс строки
/// - parameter item:      Элемент перерыва
/// - parameter tableView: Таблица
func activateTimebreakCounterForExercise(_ exercise:Exercise, withIndexPath indexPath:IndexPath, forTableView tableView:UITableView, withLabelCount labelCount:UILabel, withDelegate delegate:TimerCountDownProtocol)->TimerCountdown {
    let itemOfExercise=(exercise.exerciseExecutions[(indexPath.row)] as! ExerciseTimebreak)
    let calendar=Calendar.current
    let timerDelta=calendar.date(byAdding: Calendar.Component.second, value: itemOfExercise.timeInterval+1, to: Date())
    exercise.maxItemsTotalPassedTime=timerDelta
    let itemTimer=TimerCountdown.init(withInterval:itemOfExercise.timeInterval, forOwnerParent: exercise, forLabel: labelCount, forIndex: indexPath.row, withDelegate: delegate)
    itemOfExercise.started=true
    tableView.reloadRows(at: [indexPath], with: .none)
    return itemTimer
}

/// Деактивирует таймер перерыва в строке
///
/// - parameter indexPath: Индекс строки
/// - parameter item:      Элемент перерыва
/// - parameter tableView: Таблица
func deactivateTimebreakCounter(_ timer:TimerCountdown, forTableView tableView:UITableView) {
    timer.stop()
}

/// Активирует таймер подхода в строке
///
/// - parameter indexPath: Индекс строки
/// - parameter item:      Элемент подхода
/// - parameter tableView: Таблица
func activateExecutionCounterForExercise(_ exercise:Exercise, withIndexPath indexPath:IndexPath, forTableView tableView:UITableView, withLabelCount labelCount:UILabel, withDelegate delegate:TimerCountDownProtocol)->TimerCountdown {
    let itemOfExercise=(exercise.exerciseExecutions[(indexPath.row)] as! ExerciseExecution)
    let calendar=Calendar.current
    let timerDelta=calendar.date(byAdding: Calendar.Component.second, value: itemOfExercise.timeInterval+1, to: Date())
    exercise.maxItemsTotalPassedTime=timerDelta
    let itemTimer=TimerCountdown.init(withInterval: itemOfExercise.executionType==ExerciseExecution.ExecutionTypes.ByIteration ? 24*60*60 : itemOfExercise.timeInterval, forOwnerParent: exercise, forLabel: labelCount, forIndex: indexPath.row, withDelegate: delegate)
    itemOfExercise.started=true
    tableView.reloadRows(at: [indexPath], with: .none)
    return itemTimer
}

/// Деактивирует таймер подхода в строке
///
/// - parameter item:      Элемент подхода
/// - parameter tableView: Таблица
func deactivateExecutionCounter(_ timer:TimerCountdown, forTableView tableView:UITableView) {
    timer.stop()
}

/// Устанавливает на паузу таймер подхода в строке
///
/// - parameter item:      Элемент подхода
/// - parameter tableView: Таблица
func pauseExecutionCounter(_ timer:TimerCountdown, forTableView tableView:UITableView) {
    timer.pause()
}

/// Снимает с паузы таймер подхода в строке
///
/// - parameter item:      Элемент подхода
/// - parameter tableView: Таблица
func resumeExecutionCounter(_ timer:TimerCountdown, forTableView tableView:UITableView) {
    timer.resume()
}

func activateExerciseTimer( _ exerciseTimer:inout Timer?, forExercise exercise:Exercise, withBlock blockOfControl:@escaping (Timer)->Void) {
    if exerciseTimer != nil {
        return
    }
    if exercise.timeStarted == nil {
    exercise.timeStarted=Date()
    }
    exerciseTimer=Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: blockOfControl)
}

func deactivateExerciseTimer( _ exerciseTimer:inout Timer?, forController controller:UITableViewController, withBlock blockOfControl: ()->Void) {
    if exerciseTimer != nil {
        exerciseTimer?.invalidate()
        exerciseTimer=nil
        blockOfControl()
    }
}


func setCompleteExerciseItemToIndex(_ index:Int, forExercise exercise:Exercise) {
    for itemIndex in 0...index {
        let item=exercise.exerciseExecutions[itemIndex]
        switch item  {
        case is ExerciseTimebreak:
            (item as! ExerciseTimebreak).started=false
            (item as! ExerciseTimebreak).completed=true
        case is ExerciseExecution:
            (item as! ExerciseExecution).started=false
            (item as! ExerciseExecution).stopped=false
            (item as! ExerciseExecution).completed=true
        default:
            continue
        }
        
    }
    
}

func setCompleteExercise(_ exercise:Exercise) {
    for item in exercise.exerciseExecutions {
        switch item  {
        case is ExerciseTimebreak:
            (item as! ExerciseTimebreak).started=false
            (item as! ExerciseTimebreak).completed=false
            (item as! ExerciseTimebreak).resetTimeData()
        case is ExerciseExecution:
            (item as! ExerciseExecution).started=false
            (item as! ExerciseExecution).stopped=false
            (item as! ExerciseExecution).completed=false
            (item as! ExerciseExecution).resetTimeData()
        default:
            continue
        }
        
    }
    exercise.timeStarted=nil
    exercise.passedItemsTotalTimerInterval=0
}

func setPauseExerciseItemToIndex(_ index:Int, forExercise exercise:Exercise) {
    let item=exercise.exerciseExecutions[index]
    switch item  {
    case is ExerciseExecution:
        (item as! ExerciseExecution).started=false
        (item as! ExerciseExecution).stopped=true
    default:
        break
    }
}

func setResumeExerciseItemToIndex(_ index:Int, forExercise exercise:Exercise) {
    let item=exercise.exerciseExecutions[index]
    switch item  {
    case is ExerciseExecution:
        (item as! ExerciseExecution).started=true
        (item as! ExerciseExecution).stopped=false
    default:
        break
    }
}

func updateLastActivity(_ exercise: Exercise ) {
    exercise.lastActivity=Date()
}

func copyExerciseItemDialog(_ owner:Exercise, atRow row:Int, forController controller: vcExerciseDetailTableViewController) {
    switch owner.exerciseExecutions[row] {
    case is ExerciseExecution:
        openExerciseExecutionView(owner, forExecution: (owner.exerciseExecutions[row] as! ExerciseExecution), atRow: nil, forNew: true, forController: controller)
    case is ExerciseTimebreak:
        openExerciseTimebreakView(owner, forTimebreak: (owner.exerciseExecutions[row] as! ExerciseTimebreak), atRow: nil, forNew: true, forController: controller)
    default:
        break
    }
}

func changeExerciseItemDialog(_ owner:Exercise, atRow row:Int,forController controller: vcExerciseDetailTableViewController) {
    switch owner.exerciseExecutions[row] {
    case is ExerciseExecution:
        openExerciseExecutionView(owner, forExecution: (owner.exerciseExecutions[row] as! ExerciseExecution), atRow: row, forNew: false, forController: controller)
    case is ExerciseTimebreak:
        openExerciseTimebreakView(owner, forTimebreak: (owner.exerciseExecutions[row] as! ExerciseTimebreak), atRow: row, forNew: false, forController: controller)
    default:
        break
    }
}

func deleteExerciseItemAtRowDialog(_ owner:Exercise,atRow row:Int,forController controller: vcExerciseDetailTableViewController) {
    owner.exerciseExecutions.remove(at: row)
    controller.tableView.reloadData()
}

func openExerciseExecutionView(_ exercise: Exercise, forExecution execution:ExerciseExecution?, atRow row:Int?, forNew new:Bool, forController controller:vcExerciseDetailTableViewController) {
    let vcExerciseExecutionView=controller.storyboard?.instantiateViewController(withIdentifier: "ExerciseExecutionView")
    vcExerciseExecutionView?.modalTransitionStyle = .coverVertical
    ((vcExerciseExecutionView as! UINavigationController).topViewController as! vcExerciseExecution).delegate=controller
    ((vcExerciseExecutionView as! UINavigationController).topViewController as! vcExerciseExecution).exercise=exercise
    ((vcExerciseExecutionView as! UINavigationController).topViewController as! vcExerciseExecution).forNew=new
    if (execution != nil) {
        ((vcExerciseExecutionView as! UINavigationController).topViewController as! vcExerciseExecution).execution=execution
    }
    controller.present(vcExerciseExecutionView!, animated: true, completion: nil)
}

func openTextInformationView(_ exercise: Exercise, forText text:InformationText?, atRow row:Int?, forNew new:Bool, forController controller:vcExerciseDetailTableViewController) {
    let vcTextInformationView=controller.storyboard?.instantiateViewController(withIdentifier: "TextInformationView")
    vcTextInformationView?.modalTransitionStyle = .coverVertical
    ((vcTextInformationView as! UINavigationController).topViewController as! vcTextInformation).delegate=controller
    ((vcTextInformationView as! UINavigationController).topViewController as! vcTextInformation).exercise=exercise
    if (text != nil) {
        ((vcTextInformationView as! UINavigationController).topViewController as! vcTextInformation).text=text
    }
    controller.present(vcTextInformationView!, animated: true, completion: nil)
}

func copyTimebreakItemDialog(_ owner:Exercise, atRow row:Int, forController controller: vcExerciseDetailTableViewController) {
    openExerciseTimebreakView(owner, forTimebreak: (owner.exerciseExecutions[row] as! ExerciseTimebreak), atRow: nil, forNew: true, forController: controller)
}

func openExerciseTimebreakView(_ exercise: Exercise, forTimebreak timebreak:ExerciseTimebreak?, atRow row:Int?, forNew new:Bool, forController controller:vcExerciseDetailTableViewController) {
    let vcExerciseTimebreakView=controller.storyboard?.instantiateViewController(withIdentifier: "ExerciseTimebreakView")
    vcExerciseTimebreakView?.modalTransitionStyle = .coverVertical
    ((vcExerciseTimebreakView as! UINavigationController).topViewController as! vcExerciseTimebrake).delegate=controller
    ((vcExerciseTimebreakView as! UINavigationController).topViewController as! vcExerciseTimebrake).exercise=exercise
    ((vcExerciseTimebreakView as! UINavigationController).topViewController as! vcExerciseTimebrake).forNew=new
    if (timebreak != nil) {
        ((vcExerciseTimebreakView as! UINavigationController).topViewController as! vcExerciseTimebrake).timebreak=timebreak
    }
    controller.present(vcExerciseTimebreakView!, animated: true, completion: nil)
}


func getIntervalFromCountdown(countdown:UIPickerView)->Int {
    return (countdown.selectedRow(inComponent: 0)*3600+countdown.selectedRow(inComponent: 2)*60+countdown.selectedRow(inComponent: 4)*5)
}


func doExpandCollapseTextInformation(forItemIndex index:IndexPath, ofExercise exercise:Exercise, forController controller:vcExerciseDetailTableViewController) {
    let item=exercise.exerciseInformation[index.row] as! InformationText
    item.expanded = !item.expanded
    controller.tableView.reloadRows(at: [index], with: .automatic)
}

func getAverageInformationTextCellHeight()->Int {
 return 100
}

func changeInformationItemDialog(_ owner:Exercise, atRow row:Int,forController controller: vcExerciseDetailTableViewController) {
    switch owner.exerciseInformation[row] {
    case is InformationText:
        openTextInformationView(owner, forText: (owner.exerciseInformation[row] as! InformationText), atRow: row, forNew: false, forController: controller)
    default:
        break
    }
}

func deleteInformationItemAtRowDialog(_ owner:Exercise,atRow row:Int,forController controller: vcExerciseDetailTableViewController) {
    owner.exerciseInformation.remove(at: row)
    controller.tableView.reloadData()
}

func isExerciseStarted(_ exercise:Exercise) -> Bool {
    for item in exercise.exerciseExecutions {
        switch item {
        case is ExerciseExecution:
            if ((item as! ExerciseExecution).started || (item as! ExerciseExecution).stopped || (item as! ExerciseExecution).completed) {
                return true
            }
        case is ExerciseTimebreak:
            if ((item as! ExerciseTimebreak).started || (item as! ExerciseTimebreak).completed) {
               return true
            }
        default:
            break
        }
    }
    return false
}
