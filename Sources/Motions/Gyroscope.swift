//
//  Gyroscope.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

public final class Gyroscope: BaseMotion<Gyroscope.GyroscopeInput, Gyroscope.GyroscopeOutput> {
    public typealias Input = GyroscopeInput
    public typealias Output = GyroscopeOutput

    public struct GyroscopeInput: MotionInput {
        public let timeInterval: TimeInterval
        public let operationQueue: OperationQueue

        public init(timeInterval: TimeInterval = Gyroscope.defaultTimeInterval,
                    operationQueue: OperationQueue = Gyroscope.defaultOperationQueue) {
            self.timeInterval = timeInterval
            self.operationQueue = operationQueue
        }

        public static var `default`: Self {
            .init()
        }
    }

    public struct GyroscopeOutput: MotionOutput {
        public let timestamp: TimeInterval
        public let x: Double // in rad / sec
        public let y: Double // in rad / sec
        public let z: Double // in rad / sec

        init(from rotationRate: CMRotationRate, timestamp: TimeInterval) {
            self.timestamp = timestamp
            self.x = rotationRate.x
            self.y = rotationRate.y
            self.z = rotationRate.z
        }

        init(from gyroData: CMGyroData) {
            self.init(from: gyroData.rotationRate, timestamp: gyroData.timestamp)
        }
    }
}

extension Gyroscope: Motion {
    public var isAvailable: Bool {
        motionManager.isGyroAvailable
    }

    public var isActive: Bool {
        motionManager.isGyroActive
    }

    public var lastSample: Output? {
        motionManager.gyroData.map { .init(from: $0) }
    }

    public func start(input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        if let input {
            self.input = input
        }
        motionManager.gyroUpdateInterval = self.input.timeInterval
        motionManager.startGyroUpdates(to: self.input.operationQueue) { [weak self] value, _ in
            guard let value else { return }
            let output = Output(from: value)
            completion(output)
            guard let self else { return }
            self.subject.send(output)
        }
    }

    public func stop() {
        motionManager.stopGyroUpdates()
    }
}
