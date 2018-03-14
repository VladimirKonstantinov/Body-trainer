//
//  vcExerciseTimebreakCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 13.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseTimebreakCell: UITableViewCell {

    @IBOutlet weak var lTimeInterval: UILabel!
    @IBOutlet weak var lTimebreakName: UILabel!
    @IBOutlet weak var bComplete: UIButton!
    @IBOutlet weak var bStart: UIButton!
    @IBOutlet weak var lTotalTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bStart.layer.borderWidth=1
        bStart.layer.cornerRadius=5
        bStart.layer.borderColor=UIColor.green.cgColor
        bComplete.layer.borderWidth=1
        bComplete.layer.cornerRadius=5
        bComplete.layer.borderColor=UIColor.blue.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
