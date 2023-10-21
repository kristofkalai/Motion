//
//  DeviceMotion.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

public final class DeviceMotion: BaseMotion<DeviceMotion.Input, DeviceMotion.Output> {
    public struct Input: MotionInput {
        public let sensitivity: Float
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue
        public let attitudeReferenceFrame: CMAttitudeReferenceFrame

        public init(sensitivity: Float = 40,
                    attitudeReferenceFrame: CMAttitudeReferenceFrame = .init(),
                    timeInterval: TimeInterval = defaultTimeInterval,
                    operationQueue: OperationQueue = defaultOperationQueue) {
            self.sensitivity = sensitivity
            self.attitudeReferenceFrame = attitudeReferenceFrame
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct Output {
        public let timestamp: TimeInterval
        public let attitude: CMAttitude

        public let rotationRate: Gyroscope.Output
        public let gravity: Accelerometer.Output
        public let userAcceleration: Accelerometer.Output
        public let magneticField: Magnetometer.Output
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

    public override func start(input _input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        super.start(input: _input, completion: completion)
        motionManager.deviceMotionUpdateInterval = input.timeInterval
        motionManager.startDeviceMotionUpdates(using: input.attitudeReferenceFrame, to: input.operationQueue) { [weak self] value, _ in
            guard let self, let value else { return }
            let output = output(from: value)
            completion(output)
            subject.send(output)
        }
    }

    public override func stop() {
        super.stop()
        motionManager.stopDeviceMotionUpdates()
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
        motionManager.deviceMotion.map(output)
    }
}

extension DeviceMotion {
    private func output(from value: CMDeviceMotion) -> Output {
        .init(from: value, sensitivity: input.sensitivity)
    }
}
