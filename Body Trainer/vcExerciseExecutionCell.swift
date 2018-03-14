//
//  vcExerciseExecutionCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 15.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseExecutionCell: UITableViewCell {

    @IBOutlet weak var lExecutionName: UILabel!
    @IBOutlet weak var lWeight: UILabel!
    @IBOutlet weak var lStringOfExecutionType: UILabel!
    @IBOutlet weak var lTotaTime: UILabel!
    @IBOutlet weak var bStop: UIButton!
    @IBOutlet weak var bStart: UIButton!
    @IBOutlet weak var bComplete: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        bStart.layer.borderWidth=1
        bStart.layer.cornerRadius=5
        bStart.layer.borderColor=UIColor.green.cgColor
        bStop.layer.borderWidth=1
        bStop.layer.cornerRadius=5
        bStop.layer.borderColor=UIColor.red.cgColor
        bComplete.layer.borderWidth=1
        bComplete.layer.cornerRadius=5
        bComplete.layer.borderColor=UIColor.blue.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
