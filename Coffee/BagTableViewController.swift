//
//  BagTableViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/15/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit
import Firebase

class BagTableViewController: UITableViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var originButton: UIButton!
    @IBOutlet weak var varietyButton: UIButton!
    @IBOutlet weak var farmField: UITextField!
    @IBOutlet weak var altitudeField: UITextField!
    @IBOutlet weak var producerField: UITextField!
    @IBOutlet weak var processField: UITextField!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var roasterField: UITextField!
    @IBOutlet weak var roastField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var roastDateField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    //MARK: IBAction
    @IBAction func roastFieldDidBeginEditing(_ sender: UITextField) {
        sender.inputView = roastPicker
    }
    @IBAction func roastDateDidBeginEditing(_ sender: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        sender.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    
    @IBAction func saveBag(_ sender: UIBarButtonItem) {
        updateUI()

    }
    
    //MARK: - Variables
    var bag: Bag? { didSet { updateUI() } }
    private var user: User! { didSet { self.bag = user.bags.first } }
    private var flavors: [Flavor] = [Flavor]()
    private var brandName: String = "Ethiopia Heirloom" {
        didSet {
            displayNameLabel.text = brandName
        }
    }
    private func updateBrandName() {
        self.brandName = origin != nil ? (origin!.country + " " + variety) : self.variety
    }
    private var origin: Origin? {
        didSet {
            if let country = origin?.country {
                originButton.titleLabel?.text = country
                updateBrandName()
            }
        }
    }
    private var variety: String = "Variety" {
        didSet {
            varietyButton.titleLabel?.text = self.variety
            updateBrandName()
        }
    }
    private var farm: String = "__"
    private var altitude: Int = 0
    private var farmer: String = "__"
    private var process: String = "__"
    private var roast: Roast = .NA {
        didSet {
            roastField.text = self.roast.rawValue
            
        }
    }
    private var brewWeight: Double = 200
    private var roastDate: Date? {
        didSet {
            if let date = roastDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                
                roastDateField.text = dateFormatter.string(from: date)
            }
        }
    }
    
    var dictionary: [String: Any] {
//        return [Bag.Key.brandName: self.brandName,
//                Bag.Key.brewWeight: self.brewWeight]
        
        return [String: Any]()
    }
    
    private var roastPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabBarViewController
        self.user = tbvc.user
        
        self.roastPicker.delegate = self
        self.roastPicker.dataSource = self
        addInputAccessories(for: roastField)
        addInputAccessories(for: roastDateField)
    }
    
    func updateUI() {
        guard let bag = bag else {
            return
        }
        self.displayNameLabel.text = bag.stringValue(for: .displayName)
        self.originButton.titleLabel?.text = bag.stringValue(for: .origin)
        self.varietyButton.titleLabel?.text = bag.stringValue(for: .variety)
        self.producerField.text = bag.stringValue(for: .producer)
        print(bag.stringValue(for: .producer))
        self.farmField.text = bag.stringValue(for: .farm)
        self.altitudeField.text = bag.stringValue(for: .altitude)
        self.processField.text = bag.stringValue(for: .process)
        self.brandField.text = bag.stringValue(for: .brand)
        self.roasterField.text = bag.stringValue(for: .roaster)
        self.roastDateField.text = bag.stringValue(for: .roastDate)
        self.roastField.text = bag.stringValue(for: .roast)
        self.priceField.text = bag.stringValue(for: .price)
        self.weightField.text = bag.stringValue(for: .weight)
    }
    
    private func addInputAccessories(for textField: UITextField) {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        keyboardToolBar.items = [doneButton]
        textField.inputAccessoryView = keyboardToolBar
    }
    @objc private func tappedDone() {
        self.view.endEditing(true)
    }
    @objc  private func datePickerValueChanged(sender: UIDatePicker) {
        roastDate = sender.date
    }
}

//MARK: - Segue
extension BagTableViewController {
    
    private struct SegueIdentifier {
        static let selectOrigin = "selectOrigin"
        static let selectVariety = "selectVariety"
        static let selectFlavor = "selectFlavor"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            fatalError("Identifier is not available")
        }
        
        //        if identifier == SegueIdentifier.selectFlavor {
        //            guard let destinationVC = segue.destination.childViewControllers.first as? FlavorTableViewController  else {
        //                fatalError("Unknown VC in segue with identifier: \(identifier)")
        //            }
        //
        //        } else {
        //
        
        
        guard let destinationVC = segue.destination.childViewControllers.first as? SelectItemTableViewController  else {
            fatalError("Unknown VC in segue with identifier: \(identifier)")
        }
        
        switch identifier {
        case SegueIdentifier.selectOrigin:
            
            destinationVC.didSelect = { [weak self] (origin) in
                if let vc = self {
                    vc.origin = origin as? Origin
                }
            }
            destinationVC.sourceItems = user.origins
            
            print("destinationVC.sourceOrigins.count: \(destinationVC.sourceItems.count)")
            
        case SegueIdentifier.selectVariety:
            destinationVC.didSelect = { [weak self] (variety) in
                if let vc = self {
                    vc.variety = variety as! String
                }
            }
            
            destinationVC.sourceItems = Coffee.varieties
            
        case SegueIdentifier.selectFlavor:
            destinationVC.didSelect = { [weak self] (flavor) in
                if let vc = self {
                    vc.flavors.append(flavor as! Flavor)
                    print("Flavor: \(vc.flavors)")
                }
            }
            
            destinationVC.didDeselect = { [weak self] (flavor) in
                if let vc = self, let deselectedFlavor = flavor as? Flavor {
                    vc.flavors.removeAll(where: { (currentFlavor) -> Bool in
                        return currentFlavor.displayName == deselectedFlavor.displayName
                    })
                    print("Flavor: \(vc.flavors)")
                }
            }
            
            destinationVC.sourceItems = Flavor.allFlavors()
            destinationVC.allowMultipleSelection = true
            
            print("destinationVC.sourceOrigins.count: \(destinationVC.sourceItems.count)")
            
        default:
            print("Unknown segue identifier")
        }
        //        }
    }
}

extension BagTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === farmField {
            farm = textField.text ?? "__"
        }
        else if textField === altitudeField {
            altitude = Int(textField.text ?? "0") ?? 0
        }
        else if textField === producerField {
            farmer = textField.text ?? "__"
        }
        else if textField === processField {
            process = processField.text ?? "__"
        }
    }
}

//MARK: PickerView Methods
extension BagTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Roast.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Roast.getCase(at: row).rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roast = Roast.getCase(at: row)
    }
}
