//
//  Magnetometer.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

public final class Magnetometer: BaseMotion<Magnetometer.Input, Magnetometer.Output> {
    public struct Input: MotionInput {
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue

        public init(timeInterval: TimeInterval = defaultTimeInterval,
                    operationQueue: OperationQueue = defaultOperationQueue) {
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct Output: MotionOutput {
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

    public override func start(input _input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        super.start(input: _input, completion: completion)
        motionManager.magnetometerUpdateInterval = input.timeInterval
        motionManager.startMagnetometerUpdates(to: input.operationQueue) { [weak self] value, _ in
            guard let self, let value else { return }
            let output = output(from: value)
            completion(output)
            subject.send(output)
        }
    }

    public override func stop() {
        super.stop()
        motionManager.stopMagnetometerUpdates()
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
        motionManager.magnetometerData.map(output)
    }
}

extension Magnetometer {
    private func output(from value: CMMagnetometerData) -> Output {
        .init(from: value)
    }
}
