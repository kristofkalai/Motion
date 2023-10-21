//
//  Gyroscope.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion

public final class Gyroscope: BaseMotion<Gyroscope.Input, Gyroscope.Output> {
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

    public override func start(input _input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        super.start(input: _input, completion: completion)
        motionManager.gyroUpdateInterval = input.timeInterval
        motionManager.startGyroUpdates(to: input.operationQueue) { [weak self] value, _ in
            guard let self, let value else { return }
            let output = output(from: value)
            completion(output)
            subject.send(output)
        }
    }

    public override func stop() {
        super.stop()
        motionManager.stopGyroUpdates()
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
        motionManager.gyroData.map(output)
    }
}

extension Gyroscope {
    private func output(from value: CMGyroData) -> Output {
        .init(from: value)
    }
}
