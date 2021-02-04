//
//  PriceAnimationView.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 04.02.2021.
//

import UIKit

final class PriceAnimationView: UIView {
    
    //MARK: - Public properties
    public var color: UIColor = .black
    public var number: Double = 0.0
    public var font: UIFont = .systemFont(ofSize: 38, weight: .heavy)
    public var duration: Double = 0.3
    
    //MARK: - Private properties
    private var intPartView: SlidingNumberView!
    private var fractPartView: SlidingNumberView!
    private var dotView: UILabel!
    
    //MARK: - Init section
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Public Methods
    func update(_ price: Double, with color: UIColor) {
        let (int, fract) = components(of: price)
        
        intPartView.startCounting(completion: {[weak self] finish in
            self?.intPartView.endNumber = int
        })
        
        fractPartView.startCounting(completion: {[weak self] finish in
            self?.fractPartView.endNumber = fract
        })
        
        dotView.change(color, widthDuration: duration)
        intPartView.change(color, widthDuration: duration)
        fractPartView.change(color, widthDuration: duration)
    }
    
    //MARK: - Private methods
    private func commonInit() {
        intPartView = SlidingNumberView(startNumber: "00000", endNumber: "00000", font: self.font)
        intPartView.animationDuration = self.duration
        self.addSubview(intPartView)
        intPartView.translatesAutoresizingMaskIntoConstraints = false
        intPartView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -5).isActive = true
        intPartView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        dotView = UILabel()
        dotView.text = "."
        dotView.font = self.font
        self.addSubview(dotView)
        dotView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dotView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dotView.translatesAutoresizingMaskIntoConstraints = false
        
        fractPartView = SlidingNumberView(startNumber: "00000", endNumber: "00000", font: self.font)
        fractPartView.animationDuration = self.duration
        self.addSubview(fractPartView)
        fractPartView.translatesAutoresizingMaskIntoConstraints = false
        fractPartView.leadingAnchor.constraint(equalTo: self.centerXAnchor,  constant: 3).isActive = true
        fractPartView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        fractPartView.accelerationDirection = .rightToLeft
    }
    
    private func components(of double: Double)->(String, String) {
        let string = String(format: "%.5f", double)
        let subString = string.split(separator: ".")
        return (String(subString[0]), String(subString[1]))
    }
    
}
