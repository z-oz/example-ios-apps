//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Zubeyir Ozdemir on 3/15/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {
    
    // Helpers
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tasks: [Tasks] = []
    var alltasks: [Tasks] = []
    var slectedCategory : Categories?

    @IBOutlet weak var tblTaskList: UITableView!
    @IBOutlet weak var segmentTaskType: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskListByCategoryId()
    }
    
    @IBAction func taskTypeChanged(_ sender: Any) {
        getTaskListByCategoryId()
    }
    
    func getTaskListByCategoryId() {
        var task_type = ""
        switch self.segmentTaskType.selectedSegmentIndex {
            case 0:
                task_type = "All"
            case 1:
                task_type = "Work"
            case 2:
                task_type = "Study"
            case 3:
                task_type = "Personal"
            default:
                task_type = "General"
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        if task_type == "All" {
            let byCatePredicate = NSPredicate(format: "cate_id = %d", (slectedCategory?.cate_id)!)
            request.predicate = byCatePredicate
        } else {
            let byCatePredicate = NSPredicate(format: "cate_id = %d", (slectedCategory?.cate_id)!)
            let tasktypePredicate = NSPredicate(format: "task_type = %@", task_type)
            let allPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [byCatePredicate, tasktypePredicate])
                   request.predicate = allPredicate
        }
       
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
    
    @IBAction func btnAddTaskTapped(_ sender: Any) {
        if let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
            addTaskVC.slectedCategory = self.slectedCategory
            addTaskVC.tasks = self.tasks
            addTaskVC.callback = {
                self.getTaskListByCategoryId()
            }
            self.navigationController?.present(addTaskVC, animated: true, completion: {
                
            })
        }
    }
    

}

extension TaskListViewController : UITableViewDataSource, UITableViewDelegate {
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
                getTaskListByCategoryId()
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
