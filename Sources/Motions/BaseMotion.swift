//
//  BaseMotion.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Combine
import CoreMotion

public class BaseMotion<Input: MotionInput, Output> {
    private(set) var input: Input = .default
    let subject = PassthroughSubject<Output, Never>()
    private(set) lazy var motionManager = CMMotionManager()

    public func start(input _input: Input? = nil, completion: @escaping (_ output: Output) -> Void) {
        stop()
        _input.map { input = $0 }
    }

    public func stop() {}
}
