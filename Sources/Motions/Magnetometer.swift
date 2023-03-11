//
//  Magnetometer.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

public final class Magnetometer: BaseMotion<Magnetometer.MagnetometerInput, Magnetometer.MagnetometerOutput> {
    public typealias Input = MagnetometerInput
    public typealias Output = MagnetometerOutput

    public struct MagnetometerInput: MotionInput {
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue

        public init(timeInterval: TimeInterval = Magnetometer.defaultTimeInterval,
                    operationQueue: OperationQueue = Magnetometer.defaultOperationQueue) {
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct MagnetometerOutput: MotionOutput {
        public let timestamp: TimeInterval
        public let x: Double // in microtesla
        public let y: Double // in microtesla
        public let z: Double // in microtesla

        init(from magneticField: CMMagneticField, timestamp: TimeInterval) {
            self.timestamp = timestamp
            self.x = magneticField.x
            self.y = magneticField.y
            self.z = magneticField.z
        }

        init(from magnetometerData: CMMagnetometerData) {
            self.init(from: magnetometerData.magneticField, timestamp: magnetometerData.timestamp)
        }
    }
}

extension Magnetometer: Motion {
    public var isAvailable: Bool {
        motionManager.isMagnetometerAvailable
    }

    public var isActive: Bool {
        motionManager.isMagnetometerActive
    }

    public var lastSample: Output? {
        motionManager.magnetometerData.map { .init(from: $0) }
    }

    public func start(input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        stop()
        if let input {
            self.input = input
        }
        motionManager.magnetometerUpdateInterval = self.input.timeInterval
        motionManager.startMagnetometerUpdates(to: self.input.operationQueue) { [weak self] value, _ in
            guard let value else { return }
            let output = Output(from: value)
            completion(output)
            guard let self else { return }
            self.subject.send(output)
        }
    }

    public func stop() {
        motionManager.stopMagnetometerUpdates()
    }
}
