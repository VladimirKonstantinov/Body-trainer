//
//  timerCountDownProtocol.swift
//  test
//
//  Created by Vladimir Konstantinov on 23.01.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

protocol TimerCountDownProtocol {
    func TimerCountDownPaused(itemIndex: Int)
    func TimerCountDownResumed(itemIndex: Int)
    func TimerCountDownComplete(itemIndex:Int)
    func TimerCountDownStep()
}
