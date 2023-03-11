//
//  MotionManager.swift
//  
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import CoreMotion
import UIKit
import Combine

public final class MotionManager<T: Motion> {
    private let motion: T
    private let subject = PassthroughSubject<T.Output, Never>()

    init(motion: T) {
        self.motion = motion
    }
}

extension MotionManager: Motion {
    public func start(input: T.Input? = nil, completion: @escaping (_ output: T.Output) -> Void) {
        motion.start(input: input) { [weak self] in
            self?.subject.send($0)
            completion($0)
        }
    }

    public func stop() {
        motion.stop()
    }

    public var isActive: Bool {
        motion.isActive
    }

    public var isAvailable: Bool {
        motion.isAvailable
    }

    public var lastSample: T.Output? {
        motion.lastSample
    }
}

extension MotionManager {
    public func start(input: T.Input? = nil) -> AnyPublisher<T.Output, Never> {
        start(input: input) { _ in }
        return subject.eraseToAnyPublisher()
    }

    public var publisher: AnyPublisher<T.Output, Never> {
        subject.eraseToAnyPublisher()
    }
}
