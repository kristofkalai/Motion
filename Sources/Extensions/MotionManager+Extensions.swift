//
//  MotionManager+Extensions.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

extension MotionManager<Accelerometer> {
    public static var accelerometer: Self {
        .init(motion: .init())
    }

    private static let _shared = MotionManager.accelerometer

    public var shared: MotionManager<Accelerometer> {
        Self._shared
    }
}

extension MotionManager<DeviceMotion> {
    public static var deviceMotion: Self {
        .init(motion: .init())
    }

    private static let _shared = MotionManager.deviceMotion

    public var shared: MotionManager<DeviceMotion> {
        Self._shared
    }
}

extension MotionManager<Gyroscope> {
    public static var gyroscope: Self {
        .init(motion: .init())
    }

    private static let _shared = MotionManager.gyroscope

    public var shared: MotionManager<Gyroscope> {
        Self._shared
    }
}

extension MotionManager<Magnetometer> {
    public static var magnetometer: Self {
        .init(motion: .init())
    }

    private static let _shared = MotionManager.magnetometer

    public var shared: MotionManager<Magnetometer> {
        Self._shared
    }
}
