//
//  ViewController.swift
//  OzdemirZ_TableViewApp
//
//  Created by Zubeyir Ozdemir on 03/07/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit

class RestaurantListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRestaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = DataModel.shared.restaurants[indexPath.row].name
        cell.detailTextLabel?.text = DataModel.shared.restaurants[indexPath.row].cuisines
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRestaurant = DataModel.shared.restaurants[indexPath.row]
        performSegue(withIdentifier: "ListToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail" {
            let destinationVC = segue.destination as! RestaurantDetailViewController
            destinationVC.selectedRestaurant = selectedRestaurant
        }
    }

}

