//
//  RestaurantDetailViewController.swift
//  OzdemirZ_TableViewApp
//
//  Created by Zubeyir Ozdemir on 03/07/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UITableViewController {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var cuisinesLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var specialDietsLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var featueLabel: UILabel!
    
    var selectedRestaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    private func loadData() {
        restaurantImageView.image = UIImage(named: selectedRestaurant!.name)
        nameLabel.text = selectedRestaurant?.name
        aboutLabel.text = selectedRestaurant?.about
        cuisinesLabel.text = selectedRestaurant?.cuisines
        priceRangeLabel.text = selectedRestaurant?.priceRange
        specialDietsLabel.text = selectedRestaurant?.specialDiets
        mealLabel.text = selectedRestaurant?.meals
        featueLabel.text = selectedRestaurant?.features
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
