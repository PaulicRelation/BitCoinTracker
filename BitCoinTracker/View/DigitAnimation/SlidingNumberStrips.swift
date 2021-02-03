//
//  SlidingNumberStrips.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 03.02.2021.
//

import UIKit

public class SlidingNumberStrips: UIStackView {
    
    var labelFont: UIFont!
    var displacementValue: Int!
    private var previousNumber: Int!
    var targetNumber: Int!
    var labelSize: CGSize!
    var labelColor : UIColor!
    
    var currentNumber: Int! {
        didSet {
            if let _ = previousNumber {
                if currentNumber > previousNumber {
                    // Case that number is rising up
                    currentNumber = currentNumber == 10 ? 0 : currentNumber
                } else if currentNumber < previousNumber {
                    // Case that number is going down
                    currentNumber = currentNumber == -1 ? 9 : currentNumber
                }
                if !(previousNumber == currentNumber) {
                    previousNumber = currentNumber
                }
            } else {
                previousNumber = currentNumber
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Default properties for number strips
        axis = .vertical
        distribution = .equalSpacing
        spacing = 0
        alignment = .center
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func generateCounterStrip(){
        let goingUp = targetNumber > currentNumber
        if let currentNo = currentNumber {
            var tempNo = currentNo
            for _ in 0..<displacementValue {
                let tempLabel = UILabel(frame: .zero)
                tempLabel.font = labelFont
                tempLabel.adjustsFontSizeToFitWidth = true
                tempLabel.allowsDefaultTighteningForTruncation = true
                tempLabel.textColor = labelColor
                tempLabel.text = "\(tempNo)"
                tempLabel.textAlignment = .center
                self.addArrangedSubview(tempLabel)
                
                if goingUp {
                    tempNo = tempNo + 1 == 10 ? 0 : tempNo + 1
                } else {
                    tempNo = tempNo - 1 == -1 ? 9 : tempNo - 1
                }
            }
        }
    }
}
