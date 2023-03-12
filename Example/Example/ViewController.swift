//
//  ViewController.swift
//  Example
//
//  Created by Kristof Kalai on 2023. 03. 12..
//

import Combine
import Motion
import UIKit

final class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        MotionManager
            .accelerometer
            .shared
            .start()
            .print()
            .sink { _ in }
            .store(in: &cancellables)
    }
}
