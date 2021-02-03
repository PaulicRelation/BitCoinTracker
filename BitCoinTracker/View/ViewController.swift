//
//  ViewController.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var exchangerLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var setTrackerButton: UIButton!
    @IBOutlet weak var traceSwitch: UISwitch!
    @IBOutlet weak var mainView: UIView!
    
    var intPartView: SlidingNumberView!
    var fractPartView: SlidingNumberView!
    var dot: UILabel!
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var tracker: TrackerManager = Tracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracker.priceDelegate = self
        tracker.startTracking()
        setupUI()
    }
    
    @IBAction func setTrackerAction(_ sender: UIButton) {
        showPickerView()
    }
    
    @IBAction func trackerSwitchAction(_ sender: UISwitch) {
        
        guard let x = exchangerLabel.text, let exchanger = Exchanger(rawValue: x),
              let y = currencyLabel.text, let currency = Currency(rawValue: y) else {
            traceSwitch.isOn = false
            traceSwitch.isHidden = true
            showPickerView()
            return
        }
        if traceSwitch.isOn {
            mainView.alpha = 1
            tracker.track(exchanger, with: currency)
        }else {
            mainView.alpha = 0.1
            tracker.untrack(exchanger, with: currency)
        }
    }
    
    
    
    
}

// MARK: - Private behavior extention

private extension ViewController {
    
    func setupUI() {
        mainView.isHidden = true
        traceSwitch.isHidden = true
        traceSwitch.onTintColor = .systemBlue
        
        intPartView = SlidingNumberView(startNumber: "00000", endNumber: "00000", font: UIFont.systemFont(ofSize: 38, weight: .heavy))
        intPartView.animationDuration = 0.4
        mainView.addSubview(intPartView)
        intPartView.translatesAutoresizingMaskIntoConstraints = false
        intPartView.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -5).isActive = true
        intPartView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        intPartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
  
        dot = UILabel()
        dot.text = "."
        dot.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        mainView.addSubview(dot)
        dot.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        dot.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        dot.translatesAutoresizingMaskIntoConstraints = false
        

        fractPartView = SlidingNumberView(startNumber: "00000", endNumber: "00000", font: UIFont.systemFont(ofSize: 38, weight: .heavy))
        fractPartView.animationDuration = 0.2
        mainView.addSubview(fractPartView)
        fractPartView.translatesAutoresizingMaskIntoConstraints = false
        fractPartView.leadingAnchor.constraint(equalTo: mainView.centerXAnchor,  constant: 3).isActive = true
        fractPartView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        fractPartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        fractPartView.accelerationDirection = .rightToLeft
        

        self.view.layoutIfNeeded()
    }
    
    func showPickerView() {
        
        let hider = UIView()
        hider.frame = view.frame
        hider.backgroundColor = UIColor(white: 0.4, alpha: 1)
        hider.alpha = 0
        hider.isHidden = false
        UIView.animate(withDuration: 1) {
            hider.alpha = 0.97
        }
        self.view.addSubview(hider)
        
        
        picker = UIPickerView.init()
        picker.backgroundColor = .white
        picker.alpha = 1
        picker.isOpaque = false
        picker.delegate = self
        picker.dataSource = self
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        
        hider.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = .systemGray
        let buttons = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didTapCancel)),
            UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.didTapDone))
        ]
        toolBar.items = buttons
        hider.addSubview(toolBar)
    }
    
    func setTracker(_ exchanger: Exchanger, _ currency: Currency) {
        exchangerLabel.text = exchanger.rawValue
        currencyLabel.text = currency.rawValue
        mainView.isHidden = false
        traceSwitch.isHidden = false
        traceSwitch.isOn = true
        tracker.track(exchanger, with: currency)
    }
}

// MARK: - PickerView setup

extension ViewController: UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? Exchanger.allCases.count : Currency.allCases.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? Exchanger.allCases[row].rawValue : Currency.allCases[row].rawValue
    }
}

extension ViewController: UIPickerViewDelegate  {
    @objc func didTapDone() {
        let exchangerRow = picker.selectedRow(inComponent: 0)
        let currencyRow = picker.selectedRow(inComponent: 1)
        picker.selectRow(exchangerRow, inComponent: 0, animated: true)
        picker.selectRow(currencyRow, inComponent: 1, animated: true)
        let exchanger = Exchanger.allCases[exchangerRow]
        let currency = Currency.allCases[currencyRow]
        setTracker(exchanger, currency)
        toolBar.superview!.removeFromSuperview()
    }
    
    @objc func didTapCancel() {
        toolBar.superview!.removeFromSuperview()
    }
    
}

//MARK:  -  Price Delegate
extension ViewController: PriceDelegate {
    func haveNewPrice(price: Double, isGrow: Bool) {
        let color: UIColor = isGrow ? .green : .red
        update(price, with: color)
        
    }
    
    private func update(_ price: Double, with color: UIColor) {
        func components(of double: Double)->(String, String) {
            let string = String(format: "%.5f", price)
            let subString = string.split(separator: ".")
            return (String(subString[0]), String(subString[1]))
        }
        
        let (int, fract) = components(of: price)
        
        intPartView.startCounting(completion: {[weak self] finish in
            self?.intPartView.endNumber = int
        })
       
        fractPartView.startCounting(completion: {[weak self] finish in
            self?.fractPartView.endNumber = fract
        })

        UIView.transition(with: dot, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.dot.textColor = color
        },
        completion: nil)
       
        UIView.transition(with: intPartView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.intPartView.textColor = color
        },
        completion: nil)
        
        UIView.transition(with: fractPartView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.fractPartView.textColor = color
        },
        completion: nil)
    }
    
}
