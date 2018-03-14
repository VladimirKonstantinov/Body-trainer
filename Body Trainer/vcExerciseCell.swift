//
//  vcExerciseCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 02.10.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseCell: UITableViewCell {
    
    @IBOutlet weak var lExerciseName: UILabel!
    @IBOutlet weak var imgExerciseImage: UIImageView!
    @IBOutlet weak var lLastActivity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
