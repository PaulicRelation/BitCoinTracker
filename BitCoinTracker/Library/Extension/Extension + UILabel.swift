//
//  Extension + UILabel.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 04.02.2021.
//

import UIKit.UILabel

extension UILabel {
    func change(_ color: UIColor, widthDuration duration: Double) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.textColor = color
        },
        completion: nil)
    }
}
