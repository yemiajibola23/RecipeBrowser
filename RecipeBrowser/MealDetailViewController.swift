//
//  MealDetailViewController.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/27/23.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var mealImageView: UIImageView!
    
    static let segueIdentifier = "showMealDetail"
    
    var id: String! {
        didSet {
            NetworkHandler.fetchMealDetails(with: self.id) { [weak self] result in
                switch result {
                case .success(let details):
                    self?.configureView(with: details)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func configureView(with mealDetails: [MealDetail]) {
        NetworkHandler.fetchImage(urlString: mealDetails.first!.thumbnail) { result in
            switch result {
            case .success(let image):
                self.mealImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }

}
