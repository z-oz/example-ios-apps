//
//  ViewController.swift
//  OzdemirZ_ShoppingList
//
//  Created by Zubeyir Ozdemir on 22/02/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var newListButton: UIButton!
    @IBOutlet weak var newItemButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var listLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboad))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboad() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func newListButtonPressed(_ sender: UIButton) {
        self.listLabel.text = "No Item"
        descriptionTextField.text = ""
        quantityTextField.text = ""
    }
    
    @IBAction func newItemButtonPressed(_ sender: UIButton) {
        descriptionTextField.text = ""
        quantityTextField.text = ""
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if descriptionTextField.text != "" && quantityTextField.text != "" {
            if let quantity = Int(self.quantityTextField.text!) {
                if listLabel.text! == "No Item" {
                    listLabel.text = "\(quantity)" + "x" + descriptionTextField.text!
                } else {
                    listLabel.text = listLabel.text! + "\n" + "\(quantity)" + "x" + descriptionTextField.text!
                }
            } else {
                showAlert(title: "Invalid Input", message: "Quantity should be a digit.")
            }
            
        } else {
            showAlert(title: "Invalid Input", message: "Please make sure description and quantity fields are not empty")
        }
        hideKeyboad()
    }
}

