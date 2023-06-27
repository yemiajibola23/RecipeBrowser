//
//  MealDetailViewController.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/27/23.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    var id: String! {
        didSet {
            NetworkHandler.fetchMealDetails(with: self.id) { [weak self] result in
                switch result {
                case .success(let detail):
                    self?.configureView(with: detail)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func configureView(with mealDetail: MealDetail) {
        
    }

}
