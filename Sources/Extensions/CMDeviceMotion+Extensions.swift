//
//  CMDeviceMotion+Extensions.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

extension CMDeviceMotion {
    var _sensorLocation: SensorLocation? {
        if #available(iOS 14.0, *) {
            return sensorLocation
        }
        return nil
    }
}
