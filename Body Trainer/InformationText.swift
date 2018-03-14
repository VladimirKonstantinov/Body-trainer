//
//  InformationText.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 09.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import Foundation

class InformationText {
    var name="Текстовое описание"
    var textDescription:String
    var expanded=false
    
    init(name textName:String, withDescription description:String) {
        name=textName
        textDescription=description
    }

    init(withDescription description:String) {
        textDescription=description
    }
}
