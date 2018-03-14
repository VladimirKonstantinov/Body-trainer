//
//  vcTextInformation.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 09.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcTextInformation: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var bSave: UIButton!
    
    var delegate: vcExerciseDetailTableViewController!
    var exercise:Exercise!
    var text:InformationText?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setingViewAfterLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pressBackButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressSaveButton(_ sender: UIButton) {
        if text==nil {
            _=addTextInformation(withName:tfName.text!, andDescription:tvDescription.text!, forExercise:exercise)
        }
        else {
            changeTextInformation(forText:text!, withName:tfName.text!, andDescription:tvDescription.text!)
        }
        self.dismiss(animated: true) {_ in (self.delegate.tableView.reloadData())}
    }
    
    
    func setingViewAfterLoad() {
        tfName.delegate=self
        tvDescription.delegate=self
        if text != nil {
            tfName.text=text?.name
            tvDescription.text=text?.textDescription
        }
        addDoneButtonOnKeyboard()
        verifyDataForCorrect()
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
        
        tvDescription.inputAccessoryView = doneToolbar
    }
    
}
