//
//  vcExerciseStateCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 24.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseStateCell: UITableViewCell {

    
    @IBOutlet weak var bStartExercise: UIButton!
    @IBOutlet weak var bStopExercise: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
