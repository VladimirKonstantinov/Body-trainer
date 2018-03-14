//
//  CellManager.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 08.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Cell configuring

/// Настраивает ячейку для вывода на экран
///
/// - parameter index:     Индекс ячейки в таблице
/// - parameter tableView: Таблица
///
/// - returns: Настроенная ячейка
func configureCellAtIndex(_ index:IndexPath, atTableView tableView:UITableView)->UITableViewCell {
    let item=getItemOfArray(sharedData().mainData, atIndex:index.row)
    let cellIdentifier=String("\(item)").components(separatedBy: ".").last!
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: index)
    cell.showsReorderControl=true
    switch item {
    case is Group:
        configureGroupCell(cell as! vcGroupCell,withGroup: item as! Group)
        return cell
    case is Area:
        configureAreaCell(cell as! vcAreaCell,withArea: item as! Area)
        return cell
    case is Exercise:
        configureExerciseCell(cell as! vcExerciseCell,withExercise: item as! Exercise)
        return cell
    default:
        return cell
    }
}


/// Настройка ячейки "Группа" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter group: Элемент
func configureGroupCell(_ cell:vcGroupCell,withGroup group:Group)->Void {
    cell.lGroupName.text=group.name
    cell.lAreasCount.text="Подгрупп: \(group.areas.count)"
    cell.lLastActivity.text=getActivityFromDate(group.lastActivity)
    cell.imgGroupImage.image=nil
    cell.lLastActivity.text=getActivityFromDate(group.lastActivity)
    if group.img==nil {
        return
    }
    DispatchQueue.main.async {
        if let img=group.img {
            cell.imgGroupImage.image=img
            cell.imgGroupImage.contentMode = .scaleAspectFit
        }
    }
}

/// Настройка ячейки "Область" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter area: Элемент
func configureAreaCell(_ cell:vcAreaCell,withArea area:Area)->Void {
    cell.lAreaName.text=area.name
    cell.lExercisesCount.text="Упражнений: \(area.exercises.count)"
    cell.imgAreaImage.image=nil
    cell.lLastActivity.text=getActivityFromDate(area.lastActivity)
    if area.img==nil {
        return
    }
    DispatchQueue.main.async {
        if let img=area.img {
            cell.imgAreaImage.image=img
        }
    }
}

/// Настройка ячейки "Упражнение" данными элемента
///
/// - parameter cell:  Ячейка
/// - parameter exercise: Элемент
func configureExerciseCell(_ cell:vcExerciseCell,withExercise exercise:Exercise)->Void {
    cell.lExerciseName.text=exercise.name
    cell.imgExerciseImage.image=nil
    cell.lLastActivity.text=getActivityFromDate(exercise.lastActivity)
    if exercise.img==nil {
        return
    }
    DispatchQueue.main.async {
        if let img=exercise.img {
            cell.imgExerciseImage.image=img
        }
    }
}


// MARK: - Cell actions

/// Выполняет обработку выбранной строки
///
/// - parameter tableView: Таблица строк
/// - parameter indexPath: Индекс выбранной строки
func performSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedValue=getItemOfArray(sharedData().mainData, atIndex:indexPath.row)
    let instanceType=String("\(selectedValue)").components(separatedBy: ".").last!
    switch instanceType {
    case "Group":
        (selectedValue as! Group).isOpen = (selectedValue as! Group).isOpen ? false : true
        tableView.reloadData()
    case "Area":
        (selectedValue as! Area).isOpen = (selectedValue as! Area).isOpen ? false : true
        tableView.reloadData()
        
    default:
        break
    }
}

