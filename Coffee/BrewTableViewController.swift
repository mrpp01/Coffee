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
    private var recipe: Recipe?
    private var method: Brew.Method  = .NA {
        didSet {
            self.selectMethodButton.titleLabel?.text = method.rawValue
        }
    }
    private var bag: Bag? {
        didSet {
            self.selectBagButton.titleLabel?.text = bag?.displayName
        }
    }
    
    @IBOutlet weak var selectBagButton: UIButton!
    @IBOutlet weak var selectMethodButton: UIButton!
    @IBOutlet weak var selectRecipeButton: UIButton!
    
    @IBOutlet weak var brewEquipmentImage: UIImageView!
    //MARK: Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TabBarViewController
        self.user = tbvc.user
        
        navigationItem.rightBarButtonItem?.action = #selector(save)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
//MARK: Supporting Methods
extension BrewTableViewController {
    
    @objc func save() {
//        if let _ = self.bag {
//            user.createBrew(with: self.dictionary, and: bag!)
//        }
//        else {
//            user.createBrew(with: self.dictionary)
//        }
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

//MARK: - Segue Methods

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
        
        if let destinationVC = (segue.destination as? UINavigationController)?.childViewControllers.first as? RecipeViewController {
            destinationVC.recipe = self.recipe
            destinationVC.didSaveRecipe = { [weak self] (recipe) in
                if let vc = self {
                    vc.recipe = recipe
                }
            }
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
