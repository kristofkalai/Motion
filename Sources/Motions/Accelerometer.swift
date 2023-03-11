//
//  Accelerometer.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion
import UIKit

public final class Accelerometer: BaseMotion<Accelerometer.Input, Accelerometer.Output> {
    public typealias Input = AccelerometerInput
    public typealias Output = AccelerometerOutput

    public struct AccelerometerInput: MotionInput {
        public let sensitivity: Float
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue

        public init(sensitivity: Float = 40,
                    timeInterval: TimeInterval = Accelerometer.defaultTimeInterval,
                    operationQueue: OperationQueue = Accelerometer.defaultOperationQueue) {
            self.sensitivity = sensitivity
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct AccelerometerOutput: MotionOutput {
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
}

extension Accelerometer: Motion {
    public var isAvailable: Bool {
        motionManager.isAccelerometerAvailable
    }

    public var isActive: Bool {
        motionManager.isAccelerometerActive
    }

    public var lastSample: Output? {
        motionManager.accelerometerData.map { .init(from: $0, sensitivity: input.sensitivity) }
    }

    public func start(input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        stop()
        if let input {
            self.input = input
        }
        motionManager.accelerometerUpdateInterval = self.input.timeInterval
        motionManager.startAccelerometerUpdates(to: self.input.operationQueue) { [weak self] value, _ in
            guard let self, let value else { return }
            let output = Output(from: value, sensitivity: self.input.sensitivity)
            completion(output)
            self.subject.send(output)
        }
    }

    public func stop() {
        motionManager.stopAccelerometerUpdates()
    }
}
