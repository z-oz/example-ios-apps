//
//  TVViewController.swift
//  OzdemirZ_RemoteControl2
//
//  Created by Zubeyir Ozdemir on 22/02/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit

class TVViewController: UIViewController {

    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelValue: UILabel!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var favChannelSegmented: UISegmentedControl!
    
    var newChannel: Int = 0
      
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sliderValue.text = "Speaker Volume: \(Int(slider.value))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for (index, favChannel) in DataModel.shared.favorites.enumerated() {
            favChannelSegmented.setTitle(favChannel.label, forSegmentAt: index)
        }
    }

    @IBAction func switchToggled(_ sender: UISwitch) {
        switchLabel.text = "TV Power: " + (sender.isOn ? "On" : "Off")
        switch1.setOn(sender.isOn, animated: true)
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        slider.isEnabled = true
        sliderValue.text = "Speaker Volume: \(Int(sender.value))"
    }

    @IBAction func controlDisabled(_ sender: Any) {
        let enabled = ((sender as AnyObject).isOn)
        slider.isEnabled = enabled!
        channelValue.isEnabled = enabled!
    }
    
    
    @IBAction func numbers(_ sender: UIButton) {
        if let channelTitle = sender.currentTitle {
            channelValue.text = channelTitle
        }

    }
    
    @IBAction func channelUp(_ sender: Any) {
        if let currentChannel = channelValue.text {
            newChannel = Int(currentChannel)! + 1
        }
        if newChannel < 99 {
            channelValue.text = String(newChannel)
        }
        else {return;}
    }
    
    @IBAction func channelDown(_ sender: Any) {
        if let currentChannel = channelValue.text {
            newChannel = Int(currentChannel)! - 1
        }
        if newChannel > 0 {
            channelValue.text = String(newChannel)
        }
        else {return}
    }
    
    @IBAction func favChannelSegmentChanged(_ sender: UISegmentedControl) {
        channelValue.text = "\(DataModel.shared.favorites[sender.selectedSegmentIndex].channelNumber)"
    }
    
    @IBAction func switchToDVRButtonPRessed() {
           UIView.transition(with: self.view.window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
               let vc = self.storyboard?.instantiateViewController(identifier: "DVRViewController") as! DVRViewController
               self.view.window?.rootViewController = vc
               self.view.window?.makeKeyAndVisible()
           }, completion: nil)
       }
    
}
