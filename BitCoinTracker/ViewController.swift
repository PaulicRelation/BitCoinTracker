//
//  ViewController.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Interface Builder Properties
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var exchangerLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var setTrackerButton: UIButton!
    @IBOutlet weak var traceSwitch: UISwitch!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Custom views
    var pickerShade = UIView()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var priceView = PriceAnimationView()
    var tracker: TrackerManager = Tracker()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tracker.priceDelegate = self
        tracker.startTracking()
        setupUI()
    }
    
    //MARK: - Interface Builder Methods
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

// MARK: - EXTENSIONS

//MARK:  - Price Delegate
extension ViewController: PriceDelegate {
    func haveNewPrice(price: Double, isGrow: Bool) {
        let color: UIColor = isGrow ? .green : .red
        priceView.update(price, with: color)
    }
}
//MARK: - Private section
private extension ViewController {
    
    func setupUI() {
        picker.delegate = self
        picker.dataSource = self
        mainView.isHidden = true
        traceSwitch.isHidden = true
        traceSwitch.onTintColor = .systemBlue
        mainView.addSubview(priceView)
        priceView.trailingAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        priceView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        priceView.translatesAutoresizingMaskIntoConstraints = false
        self.view.layoutIfNeeded()
    }
    
    func showPickerView() {
        pickerShade.frame = view.frame
        pickerShade.backgroundColor = UIColor(white: 0, alpha: 0)
        picker.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 0, width: UIScreen.main.bounds.size.width, height: 200)
        toolBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 0, width: UIScreen.main.bounds.size.width, height: 50)
        toolBar.barStyle = .default
        toolBar.barTintColor = .systemBlue
        
        let color = traitCollection.userInterfaceStyle == .light ? 1 : 0
        picker.backgroundColor = .init(white: CGFloat(color), alpha: 1)

    
        let buttons = [UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didTapCancel)),
                       UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.didTapDone))]
        toolBar.items = buttons
        toolBar.tintColor = .white
        view.addSubview(pickerShade)
        pickerShade.addSubview(picker)
        pickerShade.addSubview(toolBar)
        
        UIView.animate(withDuration: 0.25) { [self] in
            pickerShade.backgroundColor = UIColor(white: 0, alpha: 0.6)
            self.picker.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
            self.toolBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50)
            pickerShade.isUserInteractionEnabled = true
        }
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

// MARK: - PickerView Datasource and Delegate

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
        mainView.alpha = 1
        UIView.animate(withDuration: 0.25) {
            self.pickerShade.backgroundColor = UIColor(white: 0.4, alpha: 0)
            self.picker.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 0, width: UIScreen.main.bounds.size.width, height: 200)
            self.toolBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 0, width: UIScreen.main.bounds.size.width, height: 30)
            self.pickerShade.isUserInteractionEnabled = false
        }
    }
    @objc func didTapCancel() {
        UIView.animate(withDuration: 0.25) {
            self.pickerShade.backgroundColor = UIColor(white: 0.4, alpha: 0)
            self.picker.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 0, width: UIScreen.main.bounds.size.width, height: 200)
            self.toolBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 0, width: UIScreen.main.bounds.size.width, height: 30)
            self.pickerShade.isUserInteractionEnabled = false
        }
    }
}
