//
//  RecipeViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/24/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit

class RecipeViewController: UITableViewController {
   
    //MARK: - Outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak private var recipeNameField: UITextField!
    @IBOutlet weak private var doseField: UITextField!
    @IBOutlet weak private var ratioField: UITextField!
    @IBOutlet weak private var ratioLabel: UILabel!
    @IBOutlet weak private var grindField: UITextField!
    @IBOutlet weak private var waterField: UITextField!
    @IBOutlet weak private var temperatureField: UITextField!
    @IBOutlet weak private var finishTimeField: UITextField!
    
    //MARK: - Variables
    
    var recipe: Recipe?
    var didSaveRecipe: ((_ recipe: Recipe?) -> Void)?
    private var name: String = "" { didSet {navigationItem.title = name != "" ? name : "Recipe" } }
    private var dose: Double? = 0 { didSet { updateRatioLabel() } }
    private var water: Int? = 0 { didSet { updateRatioLabel() } }
    private var grind: Int? = 0
    private var temperature: Int? = 0
    
    private var finishTimePicker = UIPickerView()
    private var finishMinute = 0 { didSet { updateFinishTimeField() } }
    private var finishSecond = 0 { didSet { updateFinishTimeField() } }
   
    private var note: String = ""
    //MARK: - Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let _ = saveRecipe() else {
            return print("Unable to save recipe")
        }
        didSaveRecipe?(self.recipe)
        dismiss(animated: true)
    }
    @IBAction private func finishTimeFieldDidBeginEditing(_ sender: UITextField) {
        sender.inputView = finishTimePicker
    }

    //MARK: - App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.finishTimePicker.delegate = self
        self.finishTimePicker.dataSource = self
        
        if let _ = recipe { updateUI() }
    }
}


extension RecipeViewController: UITextFieldDelegate {
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let value = textField.text else {
            print("No value")
            return
        }
        
        if textField === doseField { dose = Double(value) ?? 0 }
            
        else if textField === waterField { water = Int(value) ?? 0 }
            
        else if textField ===  grindField { grind = Int(value) ?? 0 }
            
        else if textField === temperatureField { temperature = Int(value) ?? 0 }
            
        else if textField === finishTimeField {}
            
        else if textField === recipeNameField { self.name = textField.text ?? "" }
        
        if let text = doseField.text {
            navigationItem.rightBarButtonItem?.isEnabled = (text != "")
        }
    }
}

extension RecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

//MARK: - Supporting functions

extension RecipeViewController {
    
    private struct FinishTimePickerLimit {
        static let minute = 30
        static let second = 60
    }
    
    private func updateRatioLabel() {
       
        guard dose != nil && water != nil && dose! > 0.0 && water! > 0 else {
            ratioLabel.text = "0:0"
            ratioLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            return
        }
        let ratio = Double(water!) / Double(dose!)
        ratioLabel.text = "1:" + String(format: "%.2f", ratio)
        ratioLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private func updateFinishTimeField() {
        let minuteString = finishMinute < 10 ? "0\(finishMinute)" : "\(finishMinute)"
        let secondString = finishSecond < 10 ? "0\(finishSecond)" : "\(finishSecond)"
        finishTimeField.text = "\(minuteString):\(secondString)"
    }
    
    private func updateUI() {
        
    }
    
    private func saveRecipe() -> Recipe? {
        guard let dose = dose, let water = water else {
            print("Unable to save recipe with nill dose or water")
            return nil
        }
//        recipe = Recipe(name: name, dose: Int(dose), water: water, temperature: temperature, grind: grind, note: note)
        recipe = Recipe(name: self.name, dose: Int(dose), water: water, temperature: self.temperature, grind: grind, note: note)
        return self.recipe
    }
}
