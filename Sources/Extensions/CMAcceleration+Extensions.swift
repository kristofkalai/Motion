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
        let isNearValue = {
            fabsf($0 - $1) < sensitivity
        }

        let isNearValueABS = {
            isNearValue(fabsf($0), fabsf($1))
        }

        func calcTan(first: Double, second: Double) -> Float {
            Float(atan2(first, second) * 180 / .pi)
        }

        let yxAtan = calcTan(first: y, second: x)
        let zyAtan = calcTan(first: z, second: y)
        let zxAtan = calcTan(first: z, second: x)

        return if isNearValue(-90, yxAtan), isNearValueABS(180, zyAtan) {
            .portrait
        } else if isNearValueABS(180, yxAtan), isNearValueABS(180, zxAtan) {
            .landscapeLeft
        } else if isNearValueABS(.zero, yxAtan), isNearValueABS(.zero, zxAtan) {
            .landscapeRight
        } else if isNearValue(90, yxAtan), isNearValueABS(.zero, zyAtan) {
            .portraitUpsideDown
        } else if isNearValue(-90, zyAtan), isNearValue(-90, zxAtan) {
            .faceUp
        } else if isNearValue(90, zyAtan), isNearValue(90, zxAtan) {
            .faceDown
        } else {
            .unknown
        }
    }
}
