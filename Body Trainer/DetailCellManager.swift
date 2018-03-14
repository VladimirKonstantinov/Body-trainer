//
//  DetailCellManager.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 14.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Cell configuring

/// Настройка ячейки "Перерыв" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter timebreak: Элемент
func configureTimebreakCell(_ cell:vcExerciseTimebreakCell,withTimebreak timebreak:ExerciseTimebreak)->Void {
    cell.contentView.backgroundColor = timebreak.completed ? UIColor.init(red: 163/255, green: 266/255, blue: 163/255, alpha: 0.15) : UIColor.white
    cell.lTimebreakName.text=timebreak.name
//    cell.lTotalTime.text="Затрачено времени: \(getTimerStringFromInterval(timebreak.timePassed))"
    cell.lTotalTime.text="Затрачено времени: \(timebreak.timePassed)"
    cell.lTotalTime.isHidden = !timebreak.started && !timebreak.completed
    if !timebreak.started {
        cell.lTimeInterval.text="Длительность: "+getTimerStringFromInterval(timebreak.timeInterval)
    }
    else {
        cell.lTimeInterval.text=timebreak.timeIntervalRemain
    }
    cell.bStart.isEnabled = !timebreak.started && !timebreak.completed
    cell.bComplete.isEnabled = !timebreak.completed
}

/// Настройка ячейки "Подход" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter execution: Элемент
func configureExecutionCell(_ cell:vcExerciseExecutionCell,withExecution execution:ExerciseExecution)->Void {
    cell.contentView.backgroundColor = execution.completed ? UIColor.init(red: 163/255, green: 266/255, blue: 163/255, alpha: 0.15) : UIColor.white
    cell.lExecutionName.text=execution.name
    cell.lWeight.text="Вес: \(execution.weight)"
//    cell.lTotaTime.text="Затрачено времени: \(getTimerStringFromInterval(execution.timePassed))"
    cell.lTotaTime.text="Затрачено времени: \(execution.timePassed)"
    cell.lTotaTime.isHidden = !execution.started && !execution.stopped && !execution.completed
    switch execution.executionType {
    case .ByIteration:
        cell.lStringOfExecutionType.text="Повторов: \(execution.iteration!)"
    case .ByTime:
        if !execution.started {
            cell.lStringOfExecutionType.text="Длительность: "+getTimerStringFromInterval(execution.timeInterval)
        }
        else {
            cell.lStringOfExecutionType.text=execution.timeIntervalRemain
        }
    }
    cell.bStart.isEnabled = !execution.started && !execution.completed
    cell.bStop.isEnabled = execution.started && !execution.completed
    cell.bComplete.isEnabled = !execution.completed
}

/// Настройка ячейки "Тектовая информация" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter timebreak: Элемент
func configureInformationTextCell(_ cell:vcInformationTextCell,withInformation information:InformationText)->Void {
    cell.lName.text=information.name
    cell.lDescription.text=information.textDescription
    cell.bExpand.isHidden=(cell.lDescription.text?.characters.count)!<=getAverageInformationTextCellHeight()
    if information.expanded {
        cell.bExpand.setTitle("Свернуть", for: .normal)
    }
    else {
        cell.bExpand.setTitle("Развернуть", for: .normal)
    }
}

    /// Настройка ячейки "Фото" данными элемента
    ///
    /// - parameter cell:  Ячейка
    /// - parameter timebreak: Элемент
func configureInformationImageCell(_ cell:vcInformationImageCell,withInformation information:InformationImage, forController controller:AnyObject, withSelector selector:Selector)->Void {
//    func configureInformationImageCell(_ cell:vcInformationImageCell,withInformation information:InformationImage, forController controller:AnyObject, withSelector selector:Selector, andDissmissSelector selectorForDissmiss:Selector)->Void {
        cell.lName.text=information.name
        if (information.image != nil) {
            cell.imgImage.image=information.image
            cell.imgImage.contentMode = .scaleAspectFit
//            let tapGestureRecognizer=UIImageFullscreenTapGestureRecognizer(withImage: information.image!, forController: controller, withSelector:selector, andDissmissSelector:selectorForDissmiss)
            let tapGestureRecognizer = UITapGestureRecognizer(target: controller, action:selector)
            cell.imgImage.isUserInteractionEnabled=true
            cell.imgImage.addGestureRecognizer(tapGestureRecognizer)
            
        }
        }

/// Настройка ячейки "Видео" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter timebreak: Элемент
func configureInformationVideoCell(_ cell:vcInformationVideoCell,withInformation information:InformationVideo, forController controller:AnyObject, withSelector selector:Selector)->Void {
    cell.lName.text=information.name
    if (information.previewImage != nil) {
        cell.imgPreviewImage.image=information.previewImage
        cell.imgPreviewImage.contentMode = .scaleAspectFit
        cell.lDuration.text=information.duration
        let tapGestureRecognizer=UIVideoTapGestureRecognizer(withVideoPath: information.path!, forController: controller, withSelector:selector)
        cell.imgPreviewImage.isUserInteractionEnabled=true
        cell.imgPreviewImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
}

func configureExerciseStateCell(_ cell:vcExerciseStateCell,withExercise exercise:Exercise) -> Void {
    cell.bStartExercise.isEnabled=exercise.exerciseExecutions.count>1
    cell.bStopExercise.isEnabled=exercise.exerciseExecutions.count>1 && isExerciseStarted(exercise)
}

