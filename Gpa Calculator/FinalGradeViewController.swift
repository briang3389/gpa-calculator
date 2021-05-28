//
//  FinalGradeViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 6/15/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class FinalGradeViewController: UIViewController {
    
    @IBOutlet weak var q1g: UITextField!
    @IBOutlet weak var q1p: UITextField!
    @IBOutlet weak var q2g: UITextField!
    @IBOutlet weak var q2p: UITextField!
    @IBOutlet weak var q3g: UITextField!
    @IBOutlet weak var q3p: UITextField!
    @IBOutlet weak var q4g: UITextField!
    @IBOutlet weak var q4p: UITextField!
    @IBOutlet weak var feg: UITextField!
    @IBOutlet weak var fep: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func calculateButton()
    {
        var raw:Double = 0
        raw += ((Double(q1g.text!) ?? 0) * ((Double(q1p.text!) ?? 0) / 100))
        raw += ((Double(q2g.text!) ?? 0) * ((Double(q2p.text!) ?? 0) / 100))
        raw += ((Double(q3g.text!) ?? 0) * ((Double(q3p.text!) ?? 0) / 100))
        raw += ((Double(q4g.text!) ?? 0) * ((Double(q4p.text!) ?? 0) / 100))
        raw += ((Double(feg.text!) ?? 0) * ((Double(fep.text!) ?? 0) / 100))
        //let twoDecimal = removeDecimal(String(round(raw*10000)/10000))
        let fullRound = removeDecimal(String(round(raw)))
        displayAlert(fullRound+"%","Unrounded: "+removeDecimal(String(raw))+"%")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
