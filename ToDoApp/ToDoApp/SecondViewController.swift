//
//  SecondViewController.swift
//  ToDoApp
//
//  Created by Zubeyir Ozdemiron 3/14/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    // Helpers
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var catCollectionView: UICollectionView!
    var categories: [Categories] = []
    var filteredCategories: [Categories] = []
    
    var textFieldCategory: UITextField?

    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textFieldCategory = textField!        //Save reference to the UITextField
            self.textFieldCategory?.placeholder = "Enter Category Name";
        }
    }

    func showAddCategoryAddView() {
        let alert = UIAlertController(title: "Add Category", message: "Enter category name in below text field.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            self.createCategory()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getCategoriesList()
    }

    
    func getCategoriesList() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        do {
            let result = try managedObjectContext.fetch(request)
            categories = result as! [Categories]
            print("Fetch Data", result)
            self.catCollectionView.reloadData()
        } catch  {
            print("Fetch Failed")
        }
        
    }
    
    func createCategory() {
        
        // Create User
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        let category = Categories(context: managedObjectContext)
        
        // Configure User
        category.cate_name =  textFieldCategory?.text
        category.cate_id = Int16(categories.count + 1)
        category.tasks_count = 0
        
        do {
            try managedObjectContext.save()
            
        } catch {
            print("Failed saving category")
        }
        
        getCategoriesList()
        
    }

}

extension SecondViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.searchBar.text?.isEmpty)! {
            return categories.count + 1
        } else {
            return filteredCategories.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell
        
        
        if indexPath.row < ((self.searchBar.text?.isEmpty)! ? categories.count : filteredCategories.count) {
            var category = Categories()
            if (self.searchBar.text?.isEmpty)! {
                category = categories[indexPath.row]
            } else {
                category = filteredCategories[indexPath.row]
            }
            
            cell?.lblCategoryName.isHidden = false
            cell?.lblTaskCount.isHidden = false
            cell?.btnAdd.isHidden = true
            
            cell?.lblCategoryName.text = category.cate_name
            cell?.lblTaskCount.text = "\(category.tasks_count) Tasks"
            return cell!
        } else {
            cell?.lblCategoryName.isHidden = true
            cell?.lblTaskCount.isHidden = true
            cell?.btnAdd.isHidden = false
            cell?.btnAdd.addTarget(self, action: #selector(btnAddClicked(_:)), for: .touchUpInside)
            return cell!
        }
        
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        self.showAddCategoryAddView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5, height: collectionView.frame.size.height / 2 - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < categories.count {
            if let taskListVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController {
                var category = Categories()
                if (self.searchBar.text?.isEmpty)! {
                    category = categories[indexPath.row]
                } else {
                    category = filteredCategories[indexPath.row]
                }
                taskListVC.slectedCategory = category
                self.navigationController?.pushViewController(taskListVC, animated: true)
            }
        }
    }
    
    
}

extension SecondViewController : UISearchBarDelegate {
    
    // This method updates filteredVenueList based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        // When there is no text, filteredVenueList is the same as the original data
        self.filteredCategories = (searchBar.text?.isEmpty)! ? categories : categories.filter({(aObject: Categories) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (aObject.cate_name?.lowercased().range(of: searchText.lowercased()) != nil)
        })
        catCollectionView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    
}

