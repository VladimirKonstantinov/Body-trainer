//
//  vcAreaCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 02.10.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcAreaCell: UITableViewCell {
    
    @IBOutlet weak var lAreaName: UILabel!
    @IBOutlet weak var imgAreaImage: UIImageView!
    @IBOutlet weak var lExercisesCount: UILabel!
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
