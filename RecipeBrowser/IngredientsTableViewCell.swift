//
//  IngredientsTableViewCell.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/30/23.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    
    static let reuseIdentifier = "IngredientCell"
}
