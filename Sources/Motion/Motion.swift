//
//  Motion.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Foundation

public protocol Motion {
    associatedtype Input
    associatedtype Output

    var isAvailable: Bool { get }
    var isActive: Bool { get }
    var lastSample: Output? { get }

    func start(input: Input?, completion: @escaping (_ output: Output) -> Void)
    func stop()
}

extension Motion {
    public static var defaultTimeInterval: TimeInterval {
        0.2
    }

    public static var defaultOperationQueue: OperationQueue {
        .main
    }

    public func start(completion: @escaping (_ output: Output) -> Void) {
        start(input: nil, completion: completion)
    }
}
