//
//  FirstViewController.swift
//  ToDoApp
//
//  Created by Zubeyir Ozdemir on 3/14/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit
import CoreData
import CVCalendar
import FSCalendar

class FirstViewController: UIViewController {

//    @IBOutlet weak var menuView: CVCalendarMenuView!
//    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var tblTaskList: UITableView!
    @IBOutlet weak var lblSelectedDate: UILabel!
    // Helpers
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var tasks: [Tasks] = []
    var selectedDate = Date()
    
    @IBOutlet weak var calendarView: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.scope = .week
        self.calendarView.delegate = self
        
        
        tblTaskList.estimatedRowHeight = 75.0
        tblTaskList.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSelectedDateTask()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func getSelectedDateTask(){
        let calendar = Calendar.current
        let selectedDateYear = calendar.component(.year, from: selectedDate)
        let selectedDateMonth = calendar.component(.month, from: selectedDate)
        let selectedDateDay = calendar.component(.day, from: selectedDate)
        
        let todayDateYear = calendar.component(.year, from: Date())
        let todayDateMonth = calendar.component(.month, from: Date())
        let todayDateDay = calendar.component(.day, from: Date())
        
        if selectedDateYear == todayDateYear && selectedDateMonth == todayDateMonth && selectedDateDay == todayDateDay {
            self.lblSelectedDate.text = "Today"
        } else {
            self.lblSelectedDate.text = convertDateShortFormat(inputDate: selectedDate)
        }
        
        

        let dateFrom = selectedDate.startOfDay
        let dateTo = selectedDate.endOfDay
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "task_date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "task_date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        request.predicate = datePredicate
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        do {
            let result = try managedObjectContext.fetch(request)
            tasks = result as! [Tasks]
            print("Fetch Data", result)
            self.tblTaskList.reloadData()
        } catch  {
            print("Fetch Failed")
        }
        
    }
    
    func convertDateShortFormat(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: inputDate)
    }

}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}


extension FirstViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.btnCheck.addTarget(self, action: #selector(btnCheckClicked(_:)), for: .touchUpInside)
        cell.btnCheck.tag = indexPath.row
        let task = tasks[indexPath.row]
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.task_name ?? "")
        if task.task_status {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.lblTaskName?.attributedText = attributeString
            cell.accessoryType = .checkmark
            cell.btnCheck.isSelected = true
        } else {
            cell.lblTaskName?.attributedText = attributeString
            cell.accessoryType = .none
            cell.btnCheck.isSelected = false
        }
        
         cell.lblTaskDate?.text = convertDateFormat(inputDate: task.task_date!)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let refreshAlert = UIAlertController(title: "Confirm!", message: "Are you sure want to remove this task.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                let managedObjectContext = self.appdelegate.persistentContainer.viewContext
                self.updateCategoryTaskCount(task: self.tasks[indexPath.row])
                managedObjectContext.delete(self.tasks[indexPath.row])
                self.tasks.remove(at: indexPath.row)
                
                do {
                    try managedObjectContext.save()
                    // remove the deleted item from the `UITableView`
                    self.tblTaskList.deleteRows(at: [indexPath], with: .fade)
                } catch _ {
                }
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func updateCategoryTaskCount(task: Tasks) {
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let predicate = NSPredicate(format: "cate_id = %d", task.cate_id)
        request.predicate = predicate
        do {
            let results = try managedObjectContext.fetch(request)
            let objectUpdate = results[0] as! Categories
            objectUpdate.tasks_count = Int16(tasks.count - 1)
            do {
                try managedObjectContext.save()
            }catch let error as NSError {
              print(error.localizedFailureReason)
            }
            
        }
        catch let error as NSError {
            print(error.localizedFailureReason)
        }
    }
    
    func convertDateFormat(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH':'mm':'ss dd MMM yyyy"
        return dateFormatter.string(from: inputDate)
    }
    
    @IBAction func btnCheckClicked(_ sender: UIButton) {
        let task = self.tasks[sender.tag]
        if sender.isSelected {
            //Uncheck and task status update to not completetd
            updateTaskStatus(task: task, status: false)
        }else {
            //Check and task status update to completetd
            updateTaskStatus(task: task, status: true)
        }
    }
    
    func updateTaskStatus(task : Tasks, status: Bool) {
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "task_id = %d", task.task_id)
        request.predicate = predicate
        do {
            let results = try managedObjectContext.fetch(request)
            let objectUpdate = results[0] as! Tasks
            objectUpdate.task_status = status
            do {
                try managedObjectContext.save()
                getSelectedDateTask()
            }catch let error as NSError {
              print(error.localizedFailureReason)
            }
            self.dismiss(animated: true) {
                
            }
            
        }
        catch let error as NSError {
            print(error.localizedFailureReason)
        }
    }
    
}

extension FirstViewController : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        getSelectedDateTask()
    }
}

