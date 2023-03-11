//
//  BaseMotion.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Combine
import CoreMotion

public class BaseMotion<Input: MotionInput, Output> {
    var input: Input = .default
    let subject = PassthroughSubject<Output, Never>()
    private(set) lazy var motionManager = CMMotionManager()
}
