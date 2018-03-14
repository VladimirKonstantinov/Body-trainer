//
//  DataManager.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 01.10.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit

func fillTestData() {
    var group=addGroup("Набор массы")
    var area=addArea("Грудь, бицепсы", group)
    let exercise=addExercise("Жим лежа", area)
    _ = addTimebreak("Перерыв 1", 10, exercise)
    _ = addExecution("Подход 1", weightValue:20, executionTypeValue:ExerciseExecution.ExecutionTypes.ByIteration, timeValue: 0, iterationValue: 8, exercise)
    _ = addTimebreak(nil, nil, exercise)
    _ = addExecution("Подход 2", weightValue:30, executionTypeValue:ExerciseExecution.ExecutionTypes.ByTime, timeValue: 30, iterationValue: 0, exercise)
    _ = addTextInformation(withName: "Правила", andDescription: "I have tableview with prototype cell, in the cell I have imageview and some text under. The text label is one laine in the prototype cell, but sometimes it is more than one line, I'm loading the data to the table view after server call. The label in storyboard Lines are set to 0 and Line Break to Word Wrap. If I use Using Auto Layout in UITableView for dynamic cell layouts & variable row heights everything works because the label text is predefined, but I'm loading the data from server and I reload the tableView after the API call, and then the label is just one line.", forExercise: exercise)
    _ = addTextInformation(withName: "При завершении", andDescription: "Разминка 10 минут, коктейль. Следующий день - без напряга", forExercise: exercise)
    
    
    group=addGroup("Выносливость")
    area=addArea("Велотренажер", group)
    _=addExercise("Кросс", area)
    area=addArea("qqqqqqq", group)
    _=addExercise("aaaaaa", area)
    _=addExercise("bbbbbb", area)
    
    _=addGroup("Фитнесс")
    
}

func sharedData() -> Singletone {
    return Singletone.ref;
}

// MARK: - Service

/// Возвращает дату последней активности в виде отформатированной строки
///
/// - parameter date: Дата
///
/// - returns: Отформатированная строка даты
func getActivityFromDate(_ date:Date?)->String {
    if date==nil {
        return ""
    }
    let calendar = Calendar.current
    let fromDate = calendar.dateComponents(Set([Calendar.Component.day,Calendar.Component.month,Calendar.Component.year]), from: date!)
    let toDate = calendar.dateComponents(Set([Calendar.Component.day,Calendar.Component.month,Calendar.Component.year]), from: Date.init())
    let delta = calendar.dateComponents(Set([Calendar.Component.day]), from: fromDate, to: toDate)
    
    switch delta.day! {
    case 0:
        let formatter = DateFormatter()
        formatter.locale=Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date!)
        
    case 1:
        return "Вчера"
        
    case 2..<7:
        let formatter = DateFormatter()
        formatter.locale=Locale.current
        formatter.timeStyle = .none
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date!)
        
    default:
        let formatter = DateFormatter()
        formatter.locale=Locale.current
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: date!)
    }
}


/// Возвращает кортеж в формате (hour,minute,second)
///
/// - parameter interval: Интервал в секундах
///
/// - returns: Кортеж
func getTimerDataFromInterval(_ interval:Int)->(hours:Int,minutes:Int,seconds:Int) {
    let ti = NSInteger(interval)
    let seconds = ti % 60
    let minutes = (ti / 60) % 60
    let hours = (ti / 3600)
    return (hours,minutes,seconds)
}

/// Возвращает строку интервала в формате hh:mm:ss
///
/// - parameter interval: Интервал в секундах
///
/// - returns: Отформатированная строка интервала
func getTimerStringFromInterval(_ interval:Int)->String {
    let time=getTimerDataFromInterval(interval)
    let timeFormatter=DateFormatter()
    timeFormatter.locale=NSLocale.current
    timeFormatter.dateFormat = "HH:mm:ss"
    let dateTime=timeFormatter.date(from: "\(time.hours):\(time.minutes):\(time.seconds)")!
     return timeFormatter.string(from: dateTime)
}


// MARK: - Data managing


/// Добавляет группу упражнений
///
/// - parameter name: Наименование группы
///
/// - returns: Созданная группа
func addGroup(_ name:String)->Group {
    let group=Group(nameGroup: name);
    sharedData().mainData.append(group)
    group.isOpen=true
    return group;
}

/// Добавляет область группы упражнений
///
/// - parameter name: Наименование области
/// - parameter group: Группа области
///
/// - returns: Созданная область
func addArea(_ name:String, _ group:Group)->Area {
    let area=Area(nameArea:name)
    area.parent=group
    group.areas?.append(area)
    group.isOpen=true
    area.isOpen=true
    return area
}

/// Добавляет упражнение
///
/// - parameter name: Наименование упражнения
/// - parameter area: Область упражнения
///
/// - returns: Созданное упражнение
func addExercise(_ name:String, _ area:Area)->Exercise {
    let exercise=Exercise(nameExercise:name)
    exercise.parent=area
    area.exercises?.append(exercise)
    area.isOpen=true
    return exercise
}

/// Добавляет Информацию: Коллекция фото
///
/// - parameter name: Наименование упражнения
/// - parameter Area: Область упражнения
///
/// - returns: Созданная коллекция фото
func addInformationImageCollection(forExercise exercise:Exercise)->InformationImage {
    let imageCollection=InformationImage()
    exercise.exerciseInformation.append(imageCollection)
    return imageCollection
}

/// Добавляет Информацию: Коллекция видео
///
/// - parameter name: Наименование упражнения
/// - parameter Area: Область упражнения
///
/// - returns: Созданная коллекция видео
func addInformationVideoCollection(forExercise exercise:Exercise)->InformationVideo {
    let videoCollection=InformationVideo()
    exercise.exerciseInformation.append(videoCollection)
    return videoCollection
}

/// Формирует многомерный одномерный массив индексов развернутых элементов из одномерного многоуровненого массива данных
///
/// - parameter array: Массив данных
///
/// - returns: Многомерный массив развернутых элементов
func getIndexArray(_ array:[Group])->[(Int,Int,Int)] {
    var indexArray=[(Int,Int,Int)]()
    for indexGroup in 0...array.count-1 {
        indexArray.append((indexGroup,-1,-1))
        let areas=array[indexGroup].areas
        if array[indexGroup].isOpen && areas != nil && (areas?.count)!>0 {
            for indexArea in 0...(array[indexGroup].areas?.count)!-1 {
                indexArray.append((indexGroup,indexArea,-1))
                let exercise=array[indexGroup].areas[indexArea].exercises
                if array[indexGroup].areas[indexArea].isOpen && exercise != nil && (exercise?.count)!>0 {
                    for indexExercise in 0...(array[indexGroup].areas[indexArea].exercises?.count)!-1 {
                        indexArray.append((indexGroup,indexArea,indexExercise))
                    }
                }
            }
        }
    }
    return indexArray
}

/// Возвращает количество элементов одномерного массива данных с учетом развернутых элементов
///
/// - parameter array: Массив данных
///
/// - returns: Количество элементов одномерного массива данных
func getCountOfIndexArray(_ array:[Group]) ->Int {
    return array.count==0 ? 0:getIndexArray(array).count
}

/// Возвращает элемент одномерного многоуровневого массива данных по его индексу с учетом равзернутых элементов
///
/// - parameter array: Массив данных
/// - parameter index: Индекс элемента
///
/// - returns: Элемент массива данных
func getItemOfArray(_ array:[Group], atIndex index:Int) -> AnyObject {
    let indexArray=getIndexArray(array)
    let (groupIndex,areaIndex,exerciseIndex)=indexArray[index];
    switch (groupIndex,areaIndex,exerciseIndex) {
    case (_,-1,-1):
        return array[groupIndex]
    case (_,_,-1):
        return array[groupIndex].areas![areaIndex]
    default:
        return array[groupIndex].areas![areaIndex].exercises![exerciseIndex]
    }
}

/// Изменяет наименование элемента
///
/// - parameter owner: Элемент
/// - parameter Name:  Новое наименование
func changeName (_ owner:AnyObject, newName Name:String) {
    switch owner {
    case is Group:
        (owner as! Group).name = Name
    case is Area:
        (owner as! Area).name = Name
    case is Exercise:
        (owner as! Exercise).name = Name
    case is InformationImage:
        (owner as! InformationImage).name = Name
    case is InformationVideo:
        (owner as! InformationVideo).name = Name
    default:
        return
    }
}

/// Возвращает наименование элемента
///
/// - parameter owner: Элемент
///
/// - returns: Наименование элемента
func getName (_ owner:AnyObject)->String {
    switch owner {
    case is Group:
        return (owner as! Group).name
    case is Area:
        return (owner as! Area).name
    case is Exercise:
        return (owner as! Exercise).name
    case is InformationImage:
        return (owner as! InformationImage).name
    case is InformationVideo:
        return (owner as! InformationVideo).name
    default:
        return ""
    }
}


/// Удаляет элемент в одномерном многоуровневом массиве данных по переданному номеру строки с учетом развернутых элементов
///
/// - parameter row: Номер строки
func deleteItemAtRow(_ row:Int) {
    let indexArray=getIndexArray(sharedData().mainData)
    let (groupIndex,areaIndex,exerciseIndex)=indexArray[row];
    switch (groupIndex,areaIndex,exerciseIndex) {
    case (_,-1,-1):
        sharedData().mainData.remove(at: groupIndex)
    case (_,_,-1):
        _=sharedData().mainData[groupIndex].areas!.remove(at: areaIndex)
    default:
        _=sharedData().mainData[groupIndex].areas![areaIndex].exercises!.remove(at: exerciseIndex)
    }
}

/// Возвращает элемент и его родителя одномерного многоуровневого массива данных по указанному номеру строки с учетом развернутых элементов
///
/// - parameter array: Массив данных
/// - parameter index: Номер строки
///
/// - returns: Структура: (Элемент,Индекс элемента),(Родитель элемента,Индекс родителя)
func getItemAndParentAtIndex(_ array:[Group], atIndex index: Int)-> ((AnyObject, Int),(AnyObject?,Int)) {
    let indexArray=getIndexArray(sharedData().mainData)
    let (groupIndex,areaIndex,exerciseIndex)=indexArray[index];
    switch (groupIndex,areaIndex,exerciseIndex) {
    case (_,-1,-1):
        return ((array[groupIndex],groupIndex),(nil,0))
    case (_,_,-1):
        return ((array[groupIndex].areas![areaIndex],areaIndex),(array[groupIndex],groupIndex))
    default:
        return ((array[groupIndex].areas![areaIndex].exercises![exerciseIndex],exerciseIndex),(array[groupIndex].areas![areaIndex],areaIndex))
    }
    
}


/// Перемещает элемент указанной строки одномерного многоуровневого массива данных на новое местоположение
///
/// - parameter atIndex: Номер строки "откуда"
/// - parameter toIndex: Номер строки "куда"
///
/// - returns: Результат выполнения операции
func moveRowIfPossible(atIndex:Int, toIndex:Int)->Bool {
    let ((itemAtIndex,indexItemAtIndex),(ParentAtIndex,_))=getItemAndParentAtIndex(sharedData().mainData, atIndex: atIndex)
    let ((itemToIndex,indexItemToIndex),(ParentToIndex,_))=getItemAndParentAtIndex(sharedData().mainData, atIndex: toIndex)
    switch (itemAtIndex, itemToIndex) {
    case (is Group,is Group):
        sharedData().mainData.remove(at: indexItemAtIndex)
        sharedData().mainData.insert(itemAtIndex as! Group, at: indexItemToIndex)
        return true
    case (is Area,is Group):
        (ParentAtIndex as! Group).areas.remove(at: indexItemAtIndex)
        (itemToIndex as! Group).areas.insert(itemAtIndex as! Area, at: 0)
        (itemAtIndex as! Area).parent=(itemToIndex as! Group)
        return true
    case (is Area,is Area):
        (ParentAtIndex as! Group).areas.remove(at: indexItemAtIndex)
        (ParentToIndex as! Group).areas.insert(itemAtIndex as! Area, at: indexItemToIndex)
        (itemAtIndex as! Area).parent=(ParentToIndex as! Group)
        return true
    case (is Exercise,is Area):
        (ParentAtIndex as! Area).exercises.remove(at: indexItemAtIndex)
        (itemToIndex as! Area).exercises.insert(itemAtIndex as! Exercise, at: 0)
        (itemAtIndex as! Exercise).parent=(itemToIndex as! Area)
        return true
    case (is Exercise,is Exercise):
        (ParentAtIndex as! Area).exercises.remove(at: indexItemAtIndex)
        (ParentToIndex as! Area).exercises.insert(itemAtIndex as! Exercise, at: indexItemToIndex)
        (itemAtIndex as! Exercise).parent=(ParentToIndex as! Area)
        return true
        
    default: return false
    }
}

func moveDetailRowForItem(_ item:Exercise, withType type:Int, atIndex:Int, toIndex:Int) {
    switch type {
    case 0:
        let movedItem=item.exerciseExecutions.remove(at: atIndex)
        item.exerciseExecutions.insert(movedItem, at: toIndex)
    case 1:
        let movedItem=item.exerciseInformation.remove(at: atIndex)
        item.exerciseInformation.insert(movedItem, at: toIndex)
    default:
        break
    }
}


