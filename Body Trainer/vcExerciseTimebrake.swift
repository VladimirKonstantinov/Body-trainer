//
//  vcExerciseTimebrake.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 28.02.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseTimebrake: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var pvCountdown: UIPickerView!
    @IBOutlet weak var bSave: UIButton!
    
    var delegate: vcExerciseDetailTableViewController!
    var exercise:Exercise!
    var timebreak:ExerciseTimebreak?
    var forNew:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewAfterLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    @IBAction func pressBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressSaveButton(_ sender: UIButton) {
        
        if forNew! {
            _=addTimebreak(tfName.text, getIntervalFromCountdown(countdown: pvCountdown), exercise)
        }
        else {
            fillTimebreak(timebreak!, name: self.tfName.text!, timeInterval: getIntervalFromCountdown(countdown: pvCountdown))
        }
        self.dismiss(animated: true) {_ in (self.delegate.tableView.reloadData())}
    }
    
    func setCountdownFromInterval(hours:Int,minutes:Int,seconds:Int) {
        self.pvCountdown.selectRow(hours, inComponent: 0, animated: true)
        self.pvCountdown.selectRow(minutes, inComponent: 2, animated: true)
        self.pvCountdown.selectRow(seconds/5, inComponent: 4, animated: true)
    }
    
    func fillView(_ view:vcExerciseTimebrake, name:String, interval:Int?) {
        view.tfName.text=name
        let countdown=getTimerDataFromInterval(interval==nil || interval!==0 ? 5 : interval!)
        view.setCountdownFromInterval(hours: countdown.hours, minutes: countdown.minutes, seconds: countdown.seconds)
    }
    
    func fillTimebreak(_ execution:ExerciseTimebreak, name:String, timeInterval:Int) {
        execution.name=name
        execution.timeInterval=timeInterval
    }
    
    func settingViewAfterLoad() {
        pvCountdown.delegate=self
        pvCountdown.dataSource=self
        pvCountdown.showsSelectionIndicator=true
        tfName.delegate=self
        if timebreak==nil {
            fillView(self, name: "Перерыв", interval: nil)
        }
        else {
            fillView(self, name: (timebreak?.name)!, interval: timebreak?.timeInterval)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6 // Hours, minute, second
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
        if (tfName.text?.isEmpty)! {
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
}
