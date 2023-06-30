//
//  MealDetailViewController.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/27/23.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTableview: UITableView!
    
    static let segueIdentifier = "showMealDetail"
    
    var recipeSource = RecipeSource()
    
    var id: String!
    var meal: Meal = Meal.test {
        didSet {
            self.configureView(with: self.meal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTableview.dataSource = self
        
        Task {
            do {
                meal = try await recipeSource.getMealDetails(mealID: id).meals.first ?? Meal.test
                mealImageView.image = try await recipeSource.getImage(url: meal.thumbnail)
            } catch {
                showAlert(with: error as? NetworkLayerError ?? .unknown(error.localizedDescription))
            }
        }
    }
    
    
    func configureView(with meal: Meal) {
        navigationItem.title = meal.name

        originLabel.text = meal.origin
        instructionsTextView.text = meal.instructions
        ingredientsTableview.reloadData()
    }

}

extension MealDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.reuseIdentifier, for: indexPath) as? IngredientsTableViewCell, let ingredient = meal.ingredients?[indexPath.row] else { return UITableViewCell() }
        cell.ingredientLabel.text = ingredient.name
        cell.measurementLabel.text = ingredient.measurement
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meal.ingredients?.count ?? 9
    }
}


extension UIViewController {
    func showAlert(with error: NetworkLayerError) {
            var title: String
            switch error {
            case .malformedJson:
                title = "Malformed JSON Error"
            case .urlFailure:
                title = "URL Error"
            case .networkError:
                title = "Network Failure"
//            case .empty:
//                title = "No recipes"
            case .unknown:
                title = "Unknown Issue"
            case .dataError:
                title = "Data Issue"
//            case .imageError:
//                title = "Image Error"
            case .httpError:
                title = "HTTP Error"
            case .statusError:
                title = "Status Error"
            }
            
        let alert = UIAlertController(title: title, message: error.description, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: false, completion: nil)
            
        }
}
