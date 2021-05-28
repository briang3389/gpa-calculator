//
//  EditCategoriesViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 5/14/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class EditCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet var saveButtonOutlet: UIBarButtonItem!
    
    
    var categories:Categories!
    
    var delegate:ModalHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if tableView.isEditing == false
        {
            tableView.reloadData()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "0")
        {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print(1111)
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = tableView.cellForRow(at: textFieldIndexPath!) as? CategoryCustomTableViewCell
        if cell == nil
        {
            tableView.reloadData()
            return
        }
        
        categories.categoryNames[textFieldIndexPath!.row] = cell!.nameTextField.text!
        if let weightNumber = Int(cell!.weightTextField.text!)
        {
            categories.categoryPercentages[textFieldIndexPath!.row] = weightNumber
        }
        else
        {
            categories.categoryPercentages[textFieldIndexPath!.row] = 0
            cell!.weightTextField.text = "0"
        }
        
        
        //tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.categoryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCellReuseIdentifier") as! CategoryCustomTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.nameTextField.delegate = self
        cell.weightTextField.delegate = self
        
        cell.nameTextField.text = categories.categoryNames[indexPath.row]
        cell.weightTextField.text = String(categories.categoryPercentages[indexPath.row])
        
        return cell
    }
    
    @IBAction func addCategoryButton()
    {
        categories.categoryIds.append(nextCategoryId)
        nextCategoryId += 1
        categories.categoryNames.append("")
        categories.categoryPercentages.append(0)
        
        tableView.reloadData()
    }
    
    @IBAction func editButton(_ sender: Any)
    {
        if(tableView.isEditing == false)
        {
            tableView.isEditing = true
            navigationItem.rightBarButtonItem = nil
            editButtonOutlet.title = "Done"
            view.endEditing(true)
        }
        else if(tableView.isEditing == true)
        {
            tableView.isEditing = false
            navigationItem.rightBarButtonItem = saveButtonOutlet
            editButtonOutlet.title = "Edit"
        }
    }
    
    @IBAction func saveButton(_ sender: Any)
    {
        dismiss(animated: true, completion: {
            self.delegate.modalDismissed()
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            categories.categoryIds.remove(at: indexPath.row)
            categories.categoryNames.remove(at: indexPath.row)
            categories.categoryPercentages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { //disable keyboard when
        if tableView.isEditing {
            return true
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(tableView.isEditing)
        {
            return false
        }
        return true
    }
    
    /*
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let c = tableView.cellForRow(at: indexPath)
        if(c == nil)
        {
            print("wut")
            return true
        }
        let cell = c as! CategoryCustomTableViewCell
        if(cell.nameTextField.isFirstResponder || cell.weightTextField.isFirstResponder)
        {
            return false
        }
        return true
    }
 */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
