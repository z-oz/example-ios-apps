//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Zubeyir Ozdemir on 3/16/20.
//  Copyright © Zubeyir Ozdemir. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class AddTaskViewController: UIViewController {

    var slectedCategory : Categories?
    // Helpers
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var alltasks: [Tasks] = []
    var tasks: [Tasks] = []
    let eventStore = EKEventStore()
    
    var callback : (()->())?
    
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtLink: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segmentTaskType: UISegmentedControl!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        if txtTaskName.text?.count == 0 {
            //Show Alert for task name
            self.displayError(message: "Task name is required. Please enter task name.")
        } else if !remindMeSwitch.isOn {
           //Show Alert for date selection
           self.displayError(message: "Remind me with date required. Please select ")
        } else {
            createTask()
        }
        
    }
    @IBAction func remindMeSwichValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            pickerViewHeight.constant = 247
        } else {
            pickerViewHeight.constant = 0
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    func createTask() {
        
        //get all tasks
        getAllTaskList()
        // Create User
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        let task = Tasks(context: managedObjectContext)
        
        // Configure User
        task.cate_id = slectedCategory!.cate_id
        task.task_id = Int16(alltasks.count + 1)
        task.task_name = txtTaskName.text
        task.task_date = datePicker.date
        task.task_note = txtNote.text
        task.task_link = txtLink.text
        
        switch self.segmentTaskType.selectedSegmentIndex {
            case 0:
                task.task_type = "Work"
            case 1:
                task.task_type = "Study"
            case 2:
                task.task_type = "Personal"
            default:
                task.task_type = "General"
        }
        
        do {
            try managedObjectContext.save()
            updateCategoryTaskCount()
            AddReminder()
        } catch {
            print("Failed saving category")
        }
    

    }
    
    func AddReminder() {

     eventStore.requestAccess(to: EKEntityType.reminder, completion: {
      granted, error in
      if (granted) && (error == nil) {
        print("granted \(granted)")


        let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
        reminder.title = self.txtTaskName.text
        reminder.priority = 2

        reminder.notes = self.txtNote.text
        let alarm = EKAlarm(absoluteDate: self.datePicker.date)
        reminder.addAlarm(alarm)

        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()


        do {
          try self.eventStore.save(reminder, commit: true)
        } catch {
          print("Cannot save")
          return
        }
        print("Reminder saved")
      }
     })

    }
    
    func getAllTaskList() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        do {
            let result = try managedObjectContext.fetch(request)
            alltasks = result as! [Tasks]
        } catch  {
            print("Fetch Failed")
        }
        
    }
    
    func updateCategoryTaskCount() {
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let predicate = NSPredicate(format: "cate_id = %d", (slectedCategory?.cate_id)!)
        request.predicate = predicate
        do {
            let results = try managedObjectContext.fetch(request)
            let objectUpdate = results[0] as! Categories
            objectUpdate.tasks_count = Int16(tasks.count + 1)
            do {
                try managedObjectContext.save()
            }catch let error as NSError {
              print(error.localizedFailureReason)
            }
            self.dismiss(animated: true) {
                self.callback?()
            }
            
        }
        catch let error as NSError {
            print(error.localizedFailureReason)
        }
    }
    
    func displayError(message: String) {
        let alertViewController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alertViewController, animated: true, completion: nil)
    }


}
