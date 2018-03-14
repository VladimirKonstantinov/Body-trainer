//
//  DialogManager.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 08.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// MARK: - Add/Remove/Change item


/// Открывает диалог по событию "Long press"
///
/// - parameter controller: Контроллер на котором показать диалог
/// - parameter owner:      Элемент для которого формируется диалог
/// - parameter row:        Номер строки элемента
func openLongPressItemDialog(forController controller:vcGroupTableViewController, owner:AnyObject,forRow row:Int) {
    var addString:String?
    switch owner {
    case is Group:
        addString="Добавить подгруппу"
    case is Area:
        addString="Добавить упражнение"
    default: break
    }
    
    let alert=UIAlertController.init(title: "", message: "Выберите действие", preferredStyle: .alert)
    let chancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    if (addString != nil) {
        let addItemAction=UIAlertAction.init(title: addString, style: .default) {_ in
            _=addItemDialog(owner,forController: controller)
        }
        alert.addAction(addItemAction)
    }
    let renameAction=UIAlertAction.init(title: "Переименовать", style: .default) {_ in
        _=changeNameOfItemDialog(owner,forController: controller)
    }
    let changePhotoAction=UIAlertAction.init(title: "Изменить фото", style: .default) {_ in
        _=changeItemPhotoDialog(forController:controller, withMediaTypes:[kUTTypeImage as String])
    }
    let deleteAction=UIAlertAction.init(title: "Удалить", style: .destructive) {_ in
        _=deleteItemAtRowDialog(row,forController: controller)
    }
    alert.addAction(chancelAction)
    alert.addAction(renameAction)
    alert.addAction(changePhotoAction)
    alert.addAction(deleteAction)
    controller.present(alert, animated: true, completion: nil)
}


/// Открывает диалоговое окно операции добавления элемента в зависимости от выбранного элемента
///
/// - parameter owner:      Элемент для которого формируется диалог
/// - parameter controller: Контроллер на котором показать диалог
func addItemDialog(_ owner:AnyObject?, forController controller:vcGroupTableViewController) {
    let alert=UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
    var alertTitle=""
    var alertPlaceholder=""
    switch owner {
    case nil:
        alertTitle="Добавить группу"
        alertPlaceholder="Новая группа"
        controller.okAction=UIAlertAction.init(title: "OK", style: .default) {_ in
            _=addGroup((alert.textFields?.first?.text)!)
            controller.tableView.reloadData()
        }
    case is Group:
        alertTitle="Добавить подгруппу"
        alertPlaceholder="Новая подгруппа"
        controller.okAction=UIAlertAction.init(title: "OK", style: .default) {_ in
            _=addArea((alert.textFields?.first?.text)!, owner as! Group)
            controller.tableView.reloadData()
        }
    case is Area:
        alertTitle="Добавить упражнение"
        alertPlaceholder="Новое упражнение"
        controller.okAction=UIAlertAction.init(title: "OK", style: .default) {_ in
            _=addExercise((alert.textFields?.first?.text)!, owner as! Area)
            controller.tableView.reloadData()
        }
    default:
        return
    }
    alert.title=alertTitle
    alert.addTextField(configurationHandler: {(tfName)->Void in
        tfName.placeholder=alertPlaceholder
        tfName.addTarget(controller, action: #selector(controller.textFieldTextDidChangeNotification), for: .editingChanged)
    })
    let cancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    controller.okAction!.isEnabled=false
    alert.addAction(controller.okAction!)
    alert.addAction(cancelAction)
    controller.present(alert, animated: true, completion: nil)
}


/// Открывает диалоговое окно с подтверждением удаления эелмента
///
/// - parameter row: Номер строки элемента в таблице
/// - parameter controller: Контроллер на котором показать диалог
func deleteItemAtRowDialog(_ row:Int, forController controller:vcGroupTableViewController) {
    let alert=UIAlertController.init(title: "Подтверждение", message: "Удалить данный элемент?", preferredStyle: .alert)
    let acceptingAction=UIAlertAction.init(title: "Да", style: .destructive) {_ in
        deleteItemAtRow(row)
        controller.tableView.reloadData()
    }
    let chancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    alert.addAction(acceptingAction)
    alert.addAction(chancelAction)
    controller.present(alert, animated: true, completion: nil)
}

/// Открывает диалоговое окно ввода нового наименования для выбранного элемента
///
/// - parameter item: Элемент у которого необходимо изменить наименование
/// - parameter controller: Контроллер на котором показать диалог
func changeNameOfItemDialog(_ item:AnyObject?, forController controller:AnyObject) {
    let alert=UIAlertController.init(title: "Новое имя", message: "", preferredStyle: UIAlertControllerStyle.alert)
    switch controller {
    case is vcGroupTableViewController:
        (controller as! vcGroupTableViewController).okAction=UIAlertAction.init(title: "OK", style: .default) {_ in
            changeName(item!, newName:(alert.textFields?.first?.text)!)
            (controller as! vcGroupTableViewController).tableView.reloadData()
        }
    case is vcExerciseDetailTableViewController:
        (controller as! vcExerciseDetailTableViewController).okAction=UIAlertAction.init(title: "OK", style: .default) {_ in
            changeName(item!, newName:(alert.textFields?.first?.text)!)
            (controller as! vcExerciseDetailTableViewController).tableView.reloadData()
        }
    default:
        break
    }
    alert.addTextField(configurationHandler: {(tfName)->Void in
        tfName.placeholder=getName(item!);
        tfName.addTarget(controller, action: #selector(controller.textFieldTextDidChangeNotification), for: .editingChanged)
    })
    let cancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    controller.okAction??.isEnabled=false
    alert.addAction((controller.okAction)!!)
    alert.addAction(cancelAction)
    controller.present(alert, animated: true, completion: nil)
}


/// Открывает диалоговое окно сообщения об ошибке изменения порядка элементов
///
/// - parameter controller: Контроллер на котором показать диалог
func openReorderErrorDialog(forController controller:vcGroupTableViewController) {
    let alertView=UIAlertController.init(title: "", message: "Выбрано недопустимое место", preferredStyle: .alert)
    let okAction=UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
    alertView.addAction(okAction)
    controller.present(alertView, animated: true, completion: nil)
}

func addExerciseItem(_ owner:Exercise, forController controller:vcExerciseDetailTableViewController) {
    let alert=UIAlertController.init(title: "", message: "Добавить", preferredStyle: . alert)
    let executionAction=UIAlertAction.init(title: "Подход", style: .default) { _ in
        openExerciseExecutionView(owner,forExecution: nil, atRow:nil, forNew: true, forController: controller)
    }
    let timebreakAction=UIAlertAction.init(title: "Перерыв", style: .default) { _ in
        openExerciseTimebreakView(owner,forTimebreak: nil, atRow:nil, forNew: true, forController: controller)
    }
    let cancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    alert.addAction(executionAction)
    alert.addAction(timebreakAction)
    alert.addAction(cancelAction)
    controller.present(alert, animated: true, completion: nil)
}

func addInformationItem(_ owner:Exercise, forController controller:vcExerciseDetailTableViewController) {
    let alert=UIAlertController.init(title: "", message: "Добавить", preferredStyle: . alert)
    let textInformationAction=UIAlertAction.init(title: "Текст", style: .default) { _ in
        openTextInformationView(owner,forText: nil, atRow:nil, forNew: true, forController: controller)
    }
    let imageInformationAction=UIAlertAction.init(title: "Фото/Видео", style: .default) { _ in
        _=changeItemPhotoDialog(forController:controller, withMediaTypes:[kUTTypeImage as String, kUTTypeMovie as String])
    }
    let cancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    alert.addAction(textInformationAction)
    alert.addAction(imageInformationAction)
    alert.addAction(cancelAction)
    controller.present(alert, animated: true, completion: nil)
}


// MARK: - Add/Remove/Change exercise item


/// Открывает диалог по событию "Long press"
///
/// - parameter controller: Контроллер на котором показать диалог
/// - parameter owner:      Элемент для которого формируется диалог
/// - parameter row:        Номер строки элемента
func openLongPressExerciseItemDialog(forController controller:vcExerciseDetailTableViewController, owner:Exercise,forRow row:Int) {
    let alert=UIAlertController.init(title: "", message: "Выберите действие", preferredStyle: .alert)
    let chancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    let copyAction=UIAlertAction.init(title: "Копировать", style: .default) {_ in
        _=copyExerciseItemDialog(owner,atRow:row,forController: controller)
    }
    let changeAction=UIAlertAction.init(title: "Изменить", style: .default) {_ in
        _=changeExerciseItemDialog(owner,atRow:row, forController:controller)
    }
    let deleteAction=UIAlertAction.init(title: "Удалить", style: .destructive) {_ in
        _=deleteExerciseItemAtRowDialog(owner,atRow:row,forController: controller)
    }
    alert.addAction(chancelAction)
    alert.addAction(copyAction)
    alert.addAction(changeAction)
    alert.addAction(deleteAction)
    controller.present(alert, animated: true, completion: nil)
}


// MARK: - Add/Remove/Change information item


/// Открывает диалог по событию "Long press"
///
/// - parameter controller: Контроллер на котором показать диалог
/// - parameter owner:      Элемент для которого формируется диалог
/// - parameter row:        Номер строки элемента
func openLongPressInformationItemDialog(forController controller:vcExerciseDetailTableViewController, owner:Exercise,forRow row:Int) {
    let alert=UIAlertController.init(title: "", message: "Выберите действие", preferredStyle: .alert)
    switch owner.exerciseInformation[row] {
    case is InformationText:
        let changeAction=UIAlertAction.init(title: "Изменить", style: .default) {_ in
            _=changeInformationItemDialog(owner,atRow:row, forController:controller)
        }
        alert.addAction(changeAction)
    case is InformationImage:
        let item=owner.exerciseInformation[row] as! InformationImage
        let changeAction=UIAlertAction.init(title: "Переименовать", style: .default) {_ in
            _=changeNameOfItemDialog(item, forController: controller)
        }
        let changePhotoAction=UIAlertAction.init(title: "Изменить", style: .default) {_ in
            _=changeItemPhotoDialog(forController: controller, withMediaTypes:[kUTTypeImage as String])
        }
        alert.addAction(changeAction)
        alert.addAction(changePhotoAction)
    case is InformationVideo:
        let item=owner.exerciseInformation[row] as! InformationVideo
        let changeAction=UIAlertAction.init(title: "Переименовать", style: .default) {_ in
            _=changeNameOfItemDialog(item, forController: controller)
        }
        let changePhotoAction=UIAlertAction.init(title: "Изменить", style: .default) {_ in
            _=changeItemPhotoDialog(forController: controller, withMediaTypes:[kUTTypeMovie as String])
        }
        alert.addAction(changeAction)
        alert.addAction(changePhotoAction)
    default:
        return
    }
    let deleteAction=UIAlertAction.init(title: "Удалить", style: .destructive) {_ in
        _=deleteInformationItemAtRowDialog(owner,atRow:row,forController: controller)
    }
    let chancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    alert.addAction(deleteAction)
    alert.addAction(chancelAction)
    controller.present(alert, animated: true, completion: nil)
}

// MARK: - Photo operation

/// Открывает диалоговое окно выбора фотографии
///
/// - parameter controller: Контроллер на котором показать диалог
func changeItemPhotoDialog(forController controller:UIImagePickerControllerDelegate & UINavigationControllerDelegate, withMediaTypes mediaTypes:[String]) {
    let alert=UIAlertController.init(title: "", message: "Источник", preferredStyle: .alert)
    let chancelAction=UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
    let galleryAction=UIAlertAction.init(title: "Галерея", style: .default) {_ in
        _=setItemPhotoFromGallery(forController: controller, withMediaTypes: mediaTypes)
    }
    let cameraAction=UIAlertAction.init(title: "Камера", style: .default) {_ in
        _=setItemPhotoFromCamera(forController: controller, withMediaTypes:mediaTypes)
    }
    alert.addAction(galleryAction)
    alert.addAction(cameraAction)
    alert.addAction(chancelAction)
    switch controller {
    case is vcGroupTableViewController:
        (controller as! vcGroupTableViewController).present(alert, animated: true, completion: nil)
    case is vcExerciseDetailTableViewController:
        (controller as! vcExerciseDetailTableViewController).present(alert, animated: true, completion: nil)
    default:
        break
    }
}


/// Открывает диалоговое окно для выбора фотографии из Галереи
///
/// - parameter controller: Контроллер на котором показать диалог
func setItemPhotoFromGallery(forController controller:UIImagePickerControllerDelegate & UINavigationControllerDelegate, withMediaTypes mediaTypes:[String]) {
    let imgPickerController=UIImagePickerController.init()
    imgPickerController.delegate=controller;
    imgPickerController.sourceType=UIImagePickerControllerSourceType.photoLibrary
    imgPickerController.mediaTypes=mediaTypes //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    imgPickerController.modalPresentationStyle=UIModalPresentationStyle.popover
    switch controller {
    case is vcGroupTableViewController:
        (controller as! vcGroupTableViewController).present(imgPickerController, animated: true, completion: nil)
    case is vcExerciseDetailTableViewController:
        (controller as! vcExerciseDetailTableViewController).present(imgPickerController, animated: true, completion: nil)
    default:
        break
    }
}

/// Открывает диалоговое окно для выбора фотографии с Камеры
///
func setItemPhotoFromCamera(forController controller:UIImagePickerControllerDelegate & UINavigationControllerDelegate, withMediaTypes mediaTypes:[String]) {
    let imgPickerController=UIImagePickerController.init()
    imgPickerController.delegate=controller;
    imgPickerController.sourceType=UIImagePickerControllerSourceType.camera
    imgPickerController.mediaTypes=mediaTypes //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    imgPickerController.modalPresentationStyle=UIModalPresentationStyle.popover
    imgPickerController.allowsEditing=true
    switch controller {
    case is vcGroupTableViewController:
        (controller as! vcGroupTableViewController).present(imgPickerController, animated: true, completion: nil)
    case is vcExerciseDetailTableViewController:
        (controller as! vcExerciseDetailTableViewController).present(imgPickerController, animated: true, completion: nil)
    default:
        break
    }
}


