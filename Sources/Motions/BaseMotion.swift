//
//  BaseMotion.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Channel
import CoreMotion

public class BaseMotion<Input: MotionInput, Output> {
    public private(set) var input: Input
    private(set) lazy var motionManager = CMMotionManager()

    public var channel: BaseChannel<Output>?

    init(input: Input = .default, channel: BaseChannel<Output>? = nil) {
        self.input = input
        self.channel = channel
    }

    public func start(input _input: Input?) {
        stop()
        _input.map { input = $0 }
    }

    public func stop() {}
}
