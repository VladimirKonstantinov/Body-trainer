//
//  vcGroupTableViewController.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 01.10.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcGroupTableViewController : UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public weak var okAction:UIAlertAction?
    @IBOutlet weak var orderButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var selectedRow:Int?
    
    // MARK: - Life cycle and memory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTestData()
        prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCountOfIndexArray(sharedData().mainData)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCellAtIndex(indexPath, atTableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if fromIndexPath.row==to.row {
            return
        }
        let isOk=moveRowIfPossible(atIndex: fromIndexPath.row, toIndex: to.row)
        if !isOk {
            openReorderErrorDialog(forController:self)
        }
        self.tableView.reloadData()
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSelectRow(tableView, didSelectRowAt:indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         ((segue.destination as! UINavigationController).topViewController as! vcExerciseDetailTableViewController).exercise=getItemOfArray(sharedData().mainData, atIndex: (self.tableView.indexPathForSelectedRow?.row)!) as! Exercise
        ((segue.destination as! UINavigationController).topViewController as! vcExerciseDetailTableViewController).title=((segue.destination as! UINavigationController).topViewController as! vcExerciseDetailTableViewController).exercise.name
        ((segue.destination as! UINavigationController).topViewController as! vcExerciseDetailTableViewController).delegate=self
    }
    
    // MARK: - IB action
    
    /// Переключает режим сортировки при нажатии на кнопку сортировки
    ///
    /// - parameter sender: Кнопка
    @IBAction func orderPress(_ sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.addButton.isEnabled = !self.tableView.isEditing
    }
    
    @IBAction func addItemPress(_ sender: AnyObject) {
        addItemDialog(nil, forController: self)
    }
    
    @IBAction func exitPress(_ sender: AnyObject) {
        exit(0)
    }
    
    
    // MARK: - Notifications
    
    
    /// Уведомление об изменении содержимого текстового поля
    ///
    /// - parameter textField: Текстовое поле
    func textFieldTextDidChangeNotification(textField:UITextField) {
        guard let charactersCount=textField.text?.characters.count else {
            return
        }
        self.okAction?.isEnabled=charactersCount>0;
    }
    
    
    /// Уведомление о выборе фотографии
    ///
    /// - parameter picker: Picker
    /// - parameter info:   Информация о выбранной фотографии
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if selectedRow==nil {
            return
        }
        let selectedItem=getItemOfArray(sharedData().mainData, atIndex: selectedRow!)
        if let img=info[UIImagePickerControllerOriginalImage] as? UIImage {
            setSelectedImage(img, toItem:selectedItem){_ in
                self.tableView.reloadRows(at: [IndexPath.init(row: self.selectedRow!, section: 0)], with: .automatic)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Уведомление об отмене выбора фотографии
    ///
    /// - parameter picker: Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Gestures, actions
    
    
    /// Обработка жеста "Long press"
    ///
    /// - parameter longPress: Данные жеста
    func longPressRecognizer(longPress:UILongPressGestureRecognizer) {
        if (!self.tableView.isEditing)&&(longPress.state==UIGestureRecognizerState.began) {
            let locationPoint=longPress.location(in: self.tableView)
            guard let indexPathPoint=self.tableView.indexPathForRow(at: locationPoint) else {
                addItemDialog(nil,forController: self)
                return
            }
            actionForLongPressAtRow(indexPathPoint.row)
        }
    }
    
    /// Обработка жеста "Long press" на строке
    ///
    /// - parameter row: Номер строки
    func actionForLongPressAtRow(_ row:Int) {
        selectedRow=row
        let selectedValue=getItemOfArray(sharedData().mainData, atIndex:row)
        openLongPressItemDialog(forController: self, owner: selectedValue, forRow: row)
    }
    
    
    
    // MARK: - Service
    
    
    /// Подготовка View к работе
    func prepareView() {
        let longPress=UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressRecognizer))
        self.tableView.addGestureRecognizer(longPress)
        self.clearsSelectionOnViewWillAppear = false
        
    }
    

}


