//
//  ViewController.swift
//  OzdemirZ_RemoteControl3
//
//  Created by Zubeyir Ozdemir on 24/02/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var buttonSegmentedControl: UISegmentedControl!
    @IBOutlet weak var labelTextField: UITextField!
    @IBOutlet weak var channelNumberLabel: UILabel!
    @IBOutlet weak var channelStepper: UIStepper!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reset() {
        buttonSegmentedControl.selectedSegmentIndex = 0
        labelTextField.text = ""
        channelNumberLabel.text = "1"
        channelStepper.value = 1.0
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        reset()
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        if labelTextField.text!.isEmpty == false {
            if labelTextField.text!.count > 0 && labelTextField.text!.count < 5 {
                DataModel.shared.favorites[buttonSegmentedControl.selectedSegmentIndex].label = labelTextField.text!
                DataModel.shared.favorites[buttonSegmentedControl.selectedSegmentIndex].channelNumber = Int(channelStepper.value)
                reset()
                showAlert(title: "Great!", message: "Your configuration saved successfully!")
            } else {
                showAlert(title: "Input Error", message: "Label should be between 1 to 4 letters.")
            }
        } else {
            showAlert(title: "Input Error", message: "Label should not be blank.")
        }
    }
    
    @IBAction func channnelStepperValueChanged(_ sender: UIStepper) {
        channelNumberLabel.text = "\(Int(sender.value))"
    }
    

}

