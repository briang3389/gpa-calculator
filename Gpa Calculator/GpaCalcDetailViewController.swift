//
//  GpaCalcDetailViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 4/7/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class GpaCalcDetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var levelPicker: UIPickerView!
    @IBOutlet weak var creditsPicker: UIPickerView!
    
    
    let levelPickerOptions = [" No level", " CP", " A", " H / AP"]
    let creditsPickerOptions = [" 1.25\t (Quarter year)",
                                " 2.5\t\t (Half year)",
                                " 5\t\t (Full year)",
                                " 6\t\t (Full year with lab)"]
    
    @IBAction func deleteClassButton()
    {
        indexToDelete = index
        navigationController?.popViewController(animated: true)
    }
    
    var course:Course!
    var index:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classNameTextField.delegate = self
        gradeTextField.delegate = self
        
        levelPicker.dataSource = self
        levelPicker.delegate = self
        
        creditsPicker.dataSource = self
        creditsPicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        classNameTextField.text = course.name
        gradeTextField.text = String(course.grade)
        levelPicker.selectRow(course.level, inComponent: 0, animated: false)
        creditsPicker.selectRow(Course.creditsOptions.firstIndex(of: course.credits)!, inComponent: 0, animated: false)
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        checkValuesAndSave()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        checkValuesAndSave()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(textField.text == "Class \(index+1)" || textField.text == "0" || textField.text == "0.0")
        {
            textField.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === levelPicker
        {
            return levelPickerOptions.count
        }
        else if pickerView === creditsPicker
        {
            return creditsPickerOptions.count
        }
        fatalError("3")
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        checkValuesAndSave()
    }
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        if pickerView === levelPicker
        {
            label.text = levelPickerOptions[row]
        }
        else if pickerView === creditsPicker
        {
            label.text = creditsPickerOptions[row]
        }
        else
        {
            fatalError("4")
        }
        //label.textAlignment = .left
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func checkValuesAndSave()
    {
        if classNameTextField.text! == ""
        {
            course.name = "Class \(index+1)"
            classNameTextField.text! = course.name
        }
        else
        {
            course.name = classNameTextField.text!
        }
        
        if let tmp = Int(gradeTextField.text!)
        {
            course.grade = tmp
        }
        else
        {
            course.grade = 0
            gradeTextField.text = String(course.grade)
        }
        
        course.level = levelPicker.selectedRow(inComponent: 0)
        
        course.credits = Course.creditsOptions[creditsPicker.selectedRow(inComponent: 0)]
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        checkValuesAndSave()
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
