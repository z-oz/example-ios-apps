//
//  DVRViewController.swift
//  OzdemirZ_RemoteControl2
//
//  Created by Zubeyir Ozdemir on 22/02/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit

class DVRViewController: UIViewController {
    
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var powerSwitch: UISwitch!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var fastRewindButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if powerSwitch.isOn == true {
            powerLabel.text = "On"
            changeButtonState(isEnabled: true)
        } else {
            powerLabel.text = "Off"
            changeButtonState(isEnabled: false)
        }
    }
    
    private func changeButtonState(isEnabled: Bool) {
        playButton.isEnabled = isEnabled
        stopButton.isEnabled = isEnabled
        pauseButton.isEnabled = isEnabled
        fastForwardButton.isEnabled = isEnabled
        fastRewindButton.isEnabled = isEnabled
        recordButton.isEnabled = isEnabled
    }
    
    private func showAlert(title:String, message:String, button1Title: String?, button1Handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Button 1.
        alert.addAction(UIAlertAction(title: button1Title, style: .default, handler: { (_) in
            button1Handler()
        }))
        
        // Button 2.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func powerSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            powerLabel.text = "On"
            changeButtonState(isEnabled: true)
            stateLabel.text = "Stopped"
        } else {
            powerLabel.text = "Off"
            changeButtonState(isEnabled: false)
            stateLabel.text = "-"
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        stateLabel.text = "Playing"
    }
    
    @IBAction func stopButtonPRessed(_ sender: UIButton) {
        stateLabel.text = "Stopped"
        changeButtonState(isEnabled: true)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if stateLabel.text == "Playing" || stateLabel.text == "Fast forwarding" || stateLabel.text == "Fast rewinding" {
            stateLabel.text = "Paused"
        } else {
            showAlert(title: "Warning!", message: "Pausing, fast forwarding or rewinding is only possible when the DVR is in the Playing state.", button1Title: "Continue", button1Handler: {
                self.showAlert(title: "Hey!", message: "Are you sure to change the current state?", button1Title: "OK", button1Handler: {
                    self.stateLabel.text = "Paused"
                })
            })
        }
    }
    
    @IBAction func fastForwardButtonPRessed(_ sender: UIButton) {
        if stateLabel.text == "Playing" || stateLabel.text == "Fast forwarding" || stateLabel.text == "Fast rewinding" {
            stateLabel.text = "Fast forwarding"
        } else {
            showAlert(title: "Warning!", message: "Pausing, fast forwarding or rewinding is only possible when the DVR is in the Playing state.", button1Title: "Continue", button1Handler: {
                self.showAlert(title: "Hey!", message: "Are you sure to change the current state?", button1Title: "OK", button1Handler: {
                    self.stateLabel.text = "Fast forwarding"
                })
            })
        }
    }
    
    @IBAction func fastRewindButtonPressed(_ sender: UIButton) {
        if stateLabel.text == "Playing" || stateLabel.text == "Fast forwarding" || stateLabel.text == "Fast rewinding" {
            stateLabel.text = "Fast rewinding"
        } else {
            showAlert(title: "Warning!", message: "Pausing, fast forwarding or rewinding is only possible when the DVR is in the Playing state.", button1Title: "Continue", button1Handler: {
                self.showAlert(title: "Hey!", message: "Are you sure to change the current state?", button1Title: "OK", button1Handler: {
                    self.stateLabel.text = "Fast rewinding"
                })
            })
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if stateLabel.text == "Stopped" {
            stateLabel.text = "Recording"
            playButton.isEnabled = false
            pauseButton.isEnabled = false
            fastForwardButton.isEnabled = false
            fastRewindButton.isEnabled = false
        } else {
            showAlert(title: "Warning!", message: "Playing, pausing, fast forwarding or rewinding is not possible when the DVR is in the Recording state.", button1Title: "Continue", button1Handler: {
                self.showAlert(title: "Hey!", message: "Are you sure to change the current state?", button1Title: "OK", button1Handler: {
                    self.stateLabel.text = "Recording"
                    self.playButton.isEnabled = false
                    self.pauseButton.isEnabled = false
                    self.fastForwardButton.isEnabled = false
                    self.fastRewindButton.isEnabled = false
                })
            })
        }
    }
    
    @IBAction func switchToTVButtonPRessed() {
        UIView.transition(with: self.view.window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            let vc = self.storyboard?.instantiateViewController(identifier: "TVViewController") as! TVViewController
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }, completion: nil)
    }
}

