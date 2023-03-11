//
//  DeviceMotion.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

public final class DeviceMotion: BaseMotion<DeviceMotion.DeviceMotionInput, DeviceMotion.DeviceMotionOutput> {
    public typealias Input = DeviceMotionInput
    public typealias Output = DeviceMotionOutput

    public struct DeviceMotionInput: MotionInput {
        public let sensitivity: Float
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue
        public let attitudeReferenceFrame: CMAttitudeReferenceFrame

        public init(sensitivity: Float = 40,
                    attitudeReferenceFrame: CMAttitudeReferenceFrame = .init(),
                    timeInterval: TimeInterval = DeviceMotion.defaultTimeInterval,
                    operationQueue: OperationQueue = DeviceMotion.defaultOperationQueue) {
            self.sensitivity = sensitivity
            self.attitudeReferenceFrame = attitudeReferenceFrame
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct DeviceMotionOutput {
        public let timestamp: TimeInterval
        public let attitude: CMAttitude

        public let rotationRate: Gyroscope.GyroscopeOutput
        public let gravity: Accelerometer.AccelerometerOutput
        public let userAcceleration: Accelerometer.AccelerometerOutput
        public let magneticField: Magnetometer.MagnetometerOutput
        public let magneticFieldAccuracy: CMMagneticFieldCalibrationAccuracy

        public let heading: Double
        public let sensorLocation: CMDeviceMotion.SensorLocation?

        init(from deviceMotion: CMDeviceMotion, sensitivity: Float) {
            self.timestamp = deviceMotion.timestamp
            self.attitude = deviceMotion.attitude
            self.rotationRate = .init(from: deviceMotion.rotationRate, timestamp: deviceMotion.timestamp)
            self.gravity = .init(from: deviceMotion.gravity,
                                 sensitivity: sensitivity,
                                 timestamp: deviceMotion.timestamp)
            self.userAcceleration = .init(from: deviceMotion.userAcceleration,
                                          sensitivity: sensitivity,
                                          timestamp: deviceMotion.timestamp)
            self.magneticField = .init(from: deviceMotion.magneticField.field, timestamp: deviceMotion.timestamp)
            self.magneticFieldAccuracy = deviceMotion.magneticField.accuracy
            self.heading = deviceMotion.heading
            self.sensorLocation = deviceMotion._sensorLocation
        }
    }
}

extension DeviceMotion: Motion {
    public var isAvailable: Bool {
        motionManager.isDeviceMotionAvailable
    }

    public var isActive: Bool {
        motionManager.isDeviceMotionActive
    }

    public var lastSample: Output? {
        motionManager.deviceMotion.map { .init(from: $0, sensitivity: input.sensitivity) }
    }

    public func start(input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        stop()
        if let input {
            self.input = input
        }
        motionManager.deviceMotionUpdateInterval = self.input.timeInterval
        motionManager.startDeviceMotionUpdates(using: self.input.attitudeReferenceFrame,
                                               to: self.input.operationQueue) { [weak self] deviceMotion, _ in
            guard let self, let deviceMotion else { return }
            let output = Output(from: deviceMotion, sensitivity: self.input.sensitivity)
            completion(output)
            self.subject.send(output)

        }
    }

    public func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
