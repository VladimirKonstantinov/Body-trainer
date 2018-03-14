//
//  vcInformationTextCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 09.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcInformationTextCell: UITableViewCell {

    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var lDescription: UILabel!
    @IBOutlet weak var bExpand: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
