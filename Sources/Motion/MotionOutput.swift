//
//  MotionOutput.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Foundation

protocol MotionOutput {
    var timestamp: TimeInterval { get }
    var x: Double { get }
    var y: Double { get }
    var z: Double { get }
}
