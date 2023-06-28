//
//  MealTableViewController.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/26/23.
//

import UIKit

class MealTableViewController: UITableViewController {
    var meals: [Meal]? {
        didSet {
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

        
        NetworkHandler.fetchMeals { [weak self] result in
            guard  let self = self else { return }
            switch result {
            case .failure(let networkError):
                // TODO: Show error in alert
                print(networkError)
            case .success(let meals):
//                print(meals)
                self.meals = meals
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.reuseIdentifier, for: indexPath) as? MealTableViewCell, let meal = meals?[indexPath.row] else { return UITableViewCell() }
        // Configure the cell...
        cell.configCell(with: meal)

        return cell
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == MealDetailViewController.segueIdentifier,
        let selectedIndex = tableView.indexPathForSelectedRow,
        let destination = segue.destination as? MealDetailViewController,
        let id = meals?[selectedIndex.row].id else { return }
        
        destination.id = id
        
        
    }

}
