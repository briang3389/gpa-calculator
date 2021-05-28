//
//  RootViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 4/12/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func classCalculatorButton()
    {
        let alertController = UIAlertController(title: "Select grading method", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Points", style: .default, handler: { action in self.performSegue(withIdentifier: "classCalculatorPointsSegue", sender: nil)}))
        alertController.addAction(UIAlertAction(title: "Percentages", style: .default, handler: { action in self.performSegue(withIdentifier: "classCalculatorPercentagesSegue", sender: nil)}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
