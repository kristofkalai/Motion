//
//  CMAcceleration+Extensions.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion
import UIKit

extension CMAcceleration {
    func orientation(with sensitivity: Float) -> UIDeviceOrientation {
        let isNearValue = { value1, value2 in
            fabsf(value1 - value2) < sensitivity
        }

        let isNearValueABS = { value1, value2 in
            isNearValue(fabsf(value1), fabsf(value2))
        }

        func calcTan(first: Double, second: Double) -> Float {
            Float(atan2(first, second) * 180 / .pi)
        }

        let yxAtan = calcTan(first: y, second: x)
        let zyAtan = calcTan(first: z, second: y)
        let zxAtan = calcTan(first: z, second: x)

        let orientation: UIDeviceOrientation = {
            if isNearValue(-90, yxAtan), isNearValueABS(180, zyAtan) {
                return .portrait
            } else if isNearValueABS(180, yxAtan), isNearValueABS(180, zxAtan) {
                return .landscapeLeft
            } else if isNearValueABS(.zero, yxAtan), isNearValueABS(.zero, zxAtan) {
                return .landscapeRight
            } else if isNearValue(90, yxAtan), isNearValueABS(.zero, zyAtan) {
                return .portraitUpsideDown
            } else if isNearValue(-90, zyAtan), isNearValue(-90, zxAtan) {
                return .faceUp
            } else if isNearValue(90, zyAtan), isNearValue(90, zxAtan) {
                return .faceDown
            } else {
                return .unknown
            }
        }()

        return orientation
    }
}
