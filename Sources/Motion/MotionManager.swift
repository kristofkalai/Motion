//
//  MotionManager.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Channel
import CoreMotion
import UIKit

public final class MotionManager<T: Motion> {
    private let motion: T

    init(motion: T) {
        self.motion = motion
    }
}

extension MotionManager: Motion {
    public var isActive: Bool {
        motion.isActive
    }

    public var isAvailable: Bool {
        motion.isAvailable
    }

    public var lastSample: T.Output? {
        motion.lastSample
    }

    public func start(input: T.Input?) {
        motion.start(input: input)
    }

    public func stop() {
        motion.stop()
    }
}

extension MotionManager {
    public var channel: BaseChannel<T.Output>? {
        get {
            motion.channel
        }
        set {
            motion.channel = newValue
        }
    }
}
