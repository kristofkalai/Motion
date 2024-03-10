//
//  Motion.swift
//
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Channel
import Foundation

public protocol Motion: AnyObject {
    associatedtype Input
    associatedtype Output

    var isAvailable: Bool { get }
    var isActive: Bool { get }
    var lastSample: Output? { get }

    var channel: BaseChannel<Output>? { get set }

    func start(input: Input?)
    func stop()
}

extension Motion {
    public static var defaultTimeInterval: TimeInterval {
        0.2
    }

    public static var defaultOperationQueue: OperationQueue {
        .main
    }

    public func start() {
        start(input: nil)
    }
}
