//
//  vcExerciseExecution.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 28.02.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseExecution: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var sgmItemType: UISegmentedControl!
    @IBOutlet weak var lTimeInterval: UILabel!
    @IBOutlet weak var pvCountdown: UIPickerView!
    @IBOutlet weak var lRepeats: UILabel!
    @IBOutlet weak var tfRepeats: UITextField!
    @IBOutlet weak var bSave: UIButton!
    @IBOutlet weak var stackCount: UIStackView!
    @IBOutlet weak var stackCountdown: UIStackView!
    
    var delegate: vcExerciseDetailTableViewController!
    var exercise:Exercise!
    var execution:ExerciseExecution?
    var forNew:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewAfterLoad()
        addDoneButtonOnKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pressBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressSaveButton(_ sender: UIButton) {
        if forNew! {
            _=addExecution(tfName.text, weightValue: Double(tfWeight.text!)!, executionTypeValue: sgmItemType.selectedSegmentIndex==0 ? ExerciseExecution.ExecutionTypes.ByIteration : ExerciseExecution.ExecutionTypes.ByTime , timeValue: getIntervalFromCountdown(countdown: pvCountdown), iterationValue: (sgmItemType.selectedSegmentIndex==0 ? Int(tfRepeats.text!) : nil), exercise)
        }
        else {
            fillExecution(execution!, name: self.tfName.text!, weight: Double(self.tfWeight.text!)!, executionType: sgmItemType.selectedSegmentIndex==0 ? ExerciseExecution.ExecutionTypes.ByIteration : ExerciseExecution.ExecutionTypes.ByTime,timeInterval: getIntervalFromCountdown(countdown: pvCountdown), iteration: (sgmItemType.selectedSegmentIndex==0 ? Int(tfRepeats.text!) : nil))
        }
        self.dismiss(animated: true) {_ in (self.delegate.tableView.reloadData())}
    }
    
    @IBAction func changeExerciseType(_ sender: UISegmentedControl) {
        stackCountdown.isHidden = sender.selectedSegmentIndex==0
        stackCount.isHidden = !stackCountdown.isHidden
        verifyDataForCorrect()
    }
    
    func setCountdownFromInterval(hours:Int,minutes:Int,seconds:Int) {
        self.pvCountdown.selectRow(hours, inComponent: 0, animated: true)
        self.pvCountdown.selectRow(minutes, inComponent: 2, animated: true)
        self.pvCountdown.selectRow(seconds/5, inComponent: 4, animated: true)
    }
    
    func fillView(_ view:vcExerciseExecution, name:String, weight:Double, itemType:ExerciseExecution.ExecutionTypes, interval:Int?, repeats:Int?) {
        view.tfName.text=name
        view.tfWeight.text=String(weight)
        view.sgmItemType.selectedSegmentIndex=itemType==ExerciseExecution.ExecutionTypes.ByIteration ? 0 :1
        let countdown=getTimerDataFromInterval(interval==nil || interval==0 ? 5 : interval!)
        view.setCountdownFromInterval(hours: countdown.hours, minutes: countdown.minutes, seconds: countdown.seconds)
        view.tfRepeats.text = (repeats == nil || repeats==0) ? "1" : "\(repeats!)"
        view.stackCountdown.isHidden = itemType==ExerciseExecution.ExecutionTypes.ByIteration
        view.stackCount.isHidden = itemType==ExerciseExecution.ExecutionTypes.ByTime
    }
    
    func fillExecution(_ execution:ExerciseExecution, name:String, weight:Double, executionType:ExerciseExecution.ExecutionTypes, timeInterval:Int, iteration:Int?) {
        execution.name=name
        execution.weight=weight
        execution.executionType=executionType
        execution.timeInterval=timeInterval
        execution.iteration=iteration
    }
    
    func settingViewAfterLoad() {
        pvCountdown.delegate=self
        pvCountdown.dataSource=self
        pvCountdown.showsSelectionIndicator=true
        tfName.delegate=self
        if execution==nil {
            fillView(self, name: "Подход", weight: 1, itemType: ExerciseExecution.ExecutionTypes.ByIteration, interval: nil, repeats: 8)
        }
        else {
            fillView(self, name: (execution?.name)!, weight: (execution?.weight)!, itemType: (execution?.executionType)!, interval: execution?.timeInterval, repeats: execution?.iteration)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6 // Hours, minute, second and their descriptions
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 2:
            return 60
        case 4:
            return 12
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "hour"
        case 2:
            return "\(row)"
        case 3:
            return "min"
        case 4:
            return "\(row*5)"
        case 5:
            return "sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 1,3,5:
            return 57
        default:
            return 40
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pvCountdown.selectedRow(inComponent: 0),pvCountdown.selectedRow(inComponent: 2), pvCountdown.selectedRow(inComponent: 4))==(0,0,0) && row==0 {
            pvCountdown.selectRow(1, inComponent: component, animated: true)
        }
        
    }
    
    func verifyDataForCorrect() {
        if (tfName.text?.isEmpty)! || ((tfWeight.text?.isEmpty)! || Float(tfWeight.text!)==0.0) || (sgmItemType.selectedSegmentIndex==0 && ((tfRepeats.text?.isEmpty)! || Float(tfRepeats.text!)==0.0)) {
            bSave.isEnabled = false
            return
        }
        bSave.isEnabled = true
        return
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        verifyDataForCorrect()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonAction()
        return false
    }
    
    func doneButtonAction() {
        self.view.endEditing(true)
        verifyDataForCorrect()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        tfWeight.inputAccessoryView = doneToolbar
        tfRepeats.inputAccessoryView = doneToolbar
    }
    
    
}
