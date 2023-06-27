//
//  MealTableViewCell.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/27/23.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    static let reuseIdentifier = "MealCell"
    
    func configCell(with meal: Meal) {
        nameLabel.text = meal.name
    }
}
