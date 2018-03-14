//
//  MainData.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 01.10.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import Foundation

class Singletone {
    var mainData:[Group]
    static let ref=Singletone()
    private init() {
        mainData=[Group]()
    }
}
