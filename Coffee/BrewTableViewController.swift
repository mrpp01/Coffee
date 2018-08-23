//
//  BrewTableViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/9/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit
import Firebase

class BrewTableViewController: UITableViewController {
    
    var user: User!
    private var finishTimePicker = UIPickerView()
    private struct FinishTimePickerLimit {
        static let minute = 30
        static let second = 60
    }
    private var method: Brew.Method  = .NA {
        didSet {
            self.selectMethodButton.titleLabel?.text = method.rawValue
        }
    }
    
    var finishMinute = 0 {
        didSet {
            updateFinishTimeField()
        }
    }
    
    var finishSecond = 0 {
        didSet {
            updateFinishTimeField()
        }
    }
    
    private func updateFinishTimeField() {
        let minuteString = finishMinute < 10 ? "0\(finishMinute)" : "\(finishMinute)"
        let secondString = finishSecond < 10 ? "0\(finishSecond)" : "\(finishSecond)"
        finishTimeField.text = "\(minuteString):\(secondString)"
    }
    private var bag: Bag? {
        didSet {
            self.selecBagButton.titleLabel?.text = bag?.brandName
        }
    }
    
    @IBOutlet weak var selecBagButton: UIButton!
    @IBOutlet weak var selectMethodButton: UIButton!
    @IBOutlet weak var selectRecipeButton: UIButton!
    
    private var dose: Double = 0 {
        didSet {
            updateRatioLabel()
            print("Dose: \(dose)")
        }
    }
    private var water: Int = 0 {
        didSet {
            updateRatioLabel()
            print("water: \(water)")
        }
    }
    private var grindSize: Int = 0 {
        didSet {
            print("grindSize: \(grindSize)")
        }
    }
    private var temperature: Int = 0{
        didSet {
            print("temperature: \(temperature)")
        }
    }
    
    private var dictionary: [String: Any] {
        return [ Brew.Key.dose: self.dose,
                 Brew.Key.grindSize: self.grindSize]
    }
    
    @IBOutlet weak var brewEquipmentImage: UIImageView!
    
    @IBOutlet weak var beanField: UITextField! {
        didSet {
            beanField.delegate = self
        }
    }
    
    @IBOutlet weak var ratioField: UITextField!{
        didSet {
            ratioField.delegate = self
        }
    }
    @IBOutlet weak var grindSizeField: UITextField!{
        didSet {
            grindSizeField.delegate = self
        }
    }
    
    @IBOutlet weak var doseField: UITextField! {
        didSet {
            doseField.delegate = self
        }
    }
    
    @IBOutlet weak var waterField: UITextField! {
        didSet {
            waterField.delegate = self
        }
    }
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var temperatureField: UITextField!{
        didSet {
            temperatureField.delegate = self
        }
    }
    @IBOutlet weak var finishTimeField: UITextField!{
        didSet {
            finishTimeField.delegate = self
        }
    }
    
    @IBAction func finishTimeFieldDidBeginEditing(_ sender: UITextField) {
        sender.inputView = finishTimePicker
    }
    
    //MARK: Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TabBarViewController
        self.user = tbvc.user
        self.finishTimePicker.delegate = self
        self.finishTimePicker.dataSource = self
        
        navigationItem.rightBarButtonItem?.action = #selector(save)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
//MARK: Supporting Methods
extension BrewTableViewController {
    
    @objc func save() {
        if let _ = self.bag {
            user.createBrew(with: self.dictionary, and: bag!)
        }
        else {
            user.createBrew(with: self.dictionary)
        }
    }
    
    func updateRatioLabel() {
        guard dose != 0 && water != 0 else {
            ratioLabel.text = "0:0"
            ratioLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            return
        }
        
        let ratio = Double(water) / Double(dose)
        ratioLabel.text = "1:" + String(format: "%.2f", ratio)
        ratioLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
}

extension BrewTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let value = textField.text else {
            print("No value")
            return
        }
        
        if textField === doseField { dose = Double(value) ?? 0 }
            
        else if textField === waterField { water = Int(value) ?? 0 }
            
        else if textField ===  grindSizeField { grindSize = Int(value) ?? 0 }
            
        else if textField === temperatureField { temperature = Int(value) ?? 0 }
            
        else if textField === finishTimeField {}
        
        if let text = doseField.text {
            navigationItem.rightBarButtonItem?.isEnabled = (text != "")
        }
    }
}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension BrewTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            print("Segue with no identifier")
            return
        }
        
        guard  let identifierType = Identifier(rawValue: identifier) else {
            print("Segue with identifier: \(identifier) has not been implemented")
            return
        }
        
        guard let destinationVC = (segue.destination as? UINavigationController)?.childViewControllers.first as? SelectItemTableViewController else {
            print("Failed to cast DestinationViewController as SelectItemTableViewController. Segue.Identifier: \(identifier)")
            return
        }
        
        switch identifierType {
        case .selectBag:
            destinationVC.didSelect = { [weak self](bag) in
                if let vc = self {
                    vc.bag = bag as? Bag
                }
            }
            destinationVC.sourceItems = user.bags
            print(destinationVC.sourceItems.count)
        case .selectMethod:
            destinationVC.didSelect = { [weak self](method) in
                if let vc = self, let selectedMethod = method as? Brew.Method {
                    vc.method = selectedMethod
                }
            }
            destinationVC.sourceItems = Brew.Method.all

        case .selectRecipe:
            return
        }
        
    }
    
    enum Identifier: String {
        case selectBag = "selectBag"
        case selectMethod = "selectMethod"
        case selectRecipe = "selectRecipe"
    }
}

extension BrewTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return component == 0 ? (FinishTimePickerLimit.minute + 1) : (FinishTimePickerLimit.second + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            finishMinute = row
        }
        else {
            finishSecond = row
        }
    }
    
}
