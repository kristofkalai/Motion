//
//  Accelerometer.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion
import UIKit

public final class Accelerometer: BaseMotion<Accelerometer.Input, Accelerometer.Output> {
    public struct Input: MotionInput {
        public let sensitivity: Float
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue

        public init(sensitivity: Float = 40,
                    timeInterval: TimeInterval = defaultTimeInterval,
                    operationQueue: OperationQueue = defaultOperationQueue) {
            self.sensitivity = sensitivity
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct Output: MotionOutput {
        public let timestamp: TimeInterval
        public let x: Double // in G
        public let y: Double // in G
        public let z: Double // in G

        public let orientation: UIDeviceOrientation

        init(from acceleration: CMAcceleration, sensitivity: Float, timestamp: TimeInterval) {
            self.timestamp = timestamp
            self.x = acceleration.x
            self.y = acceleration.y
            self.z = acceleration.z
            self.orientation = acceleration.orientation(with: sensitivity)
        }

        init(from accelerometerData: CMAccelerometerData, sensitivity: Float) {
            self.init(from: accelerometerData.acceleration, sensitivity: sensitivity, timestamp: accelerometerData.timestamp)
        }
    }

    public override func start(input _input: Input?) {
        super.start(input: input)
        motionManager.accelerometerUpdateInterval = self.input.timeInterval
        motionManager.startAccelerometerUpdates(to: self.input.operationQueue) { [weak self] value, _ in
            guard let self, let value else { return }
            channel?.send(value: output(from: value))
        }
    }

    public override func stop() {
        super.stop()
        motionManager.stopAccelerometerUpdates()
    }
}

extension Accelerometer: Motion {
    public var isAvailable: Bool {
        motionManager.isAccelerometerAvailable
    }

    public var isActive: Bool {
        motionManager.isAccelerometerActive
    }

    public var lastSample: Output? {
        motionManager.accelerometerData.map(output)
    }
}

extension Accelerometer {
    private func output(from value: CMAccelerometerData) -> Output {
        Output(from: value, sensitivity: input.sensitivity)
    }
}
