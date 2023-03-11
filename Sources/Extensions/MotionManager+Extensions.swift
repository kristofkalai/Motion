//
//  MotionManager+Extensions.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

extension MotionManager<Accelerometer> {
    public class var accelerometer: MotionManager<Accelerometer> {
        .init(motion: Accelerometer())
    }

    private static var _shared = MotionManager.accelerometer

    public var shared: MotionManager<Accelerometer> {
        Self._shared
    }
}

extension MotionManager<DeviceMotion> {
    public class var deviceMotion: MotionManager<DeviceMotion> {
        .init(motion: DeviceMotion())
    }

    private static var _shared = MotionManager.deviceMotion

    public var shared: MotionManager<DeviceMotion> {
        Self._shared
    }
}

extension MotionManager<Gyroscope> {
    public class var gyroscope: MotionManager<Gyroscope> {
        .init(motion: Gyroscope())
    }

    private static var _shared = MotionManager.gyroscope

    public var shared: MotionManager<Gyroscope> {
        Self._shared
    }
}

extension MotionManager<Magnetometer> {
    public class var magnetometer: MotionManager<Magnetometer> {
        .init(motion: Magnetometer())
    }

    private static var _shared = MotionManager.magnetometer

    public var shared: MotionManager<Magnetometer> {
        Self._shared
    }
}
