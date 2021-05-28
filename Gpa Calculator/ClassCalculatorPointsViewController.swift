//
//  ClassCalculatorPointsViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 4/26/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class ClassCalculatorPointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var pointsRecieved:[Double?] = [nil]
    var pointsPossible:[Double?] = [nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        var safeAreaBottomInset:CGFloat
        if #available(iOS 11.0, *) {
            safeAreaBottomInset = view.safeAreaInsets.bottom
        } else {
            safeAreaBottomInset = 0
        }
        //print(safeAreaBottomInset)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - safeAreaBottomInset - 50, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
        
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        /*
        var i=0;while i<pointsPossible.count
        {
            pointsRecieved[i] = tableView.cellForRow(at: i).pointsRecievedTextField.text
    i+=1}*/
        
        
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print(1111)
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = tableView.cellForRow(at: textFieldIndexPath!) as? ClassCalculatorPointsCustomTableViewCell
        if(cell == nil)
        {
            tableView.reloadData()
            return
        }
        pointsRecieved[textFieldIndexPath!.row] = Double(cell!.pointsRecievedTextField.text!)
        pointsPossible[textFieldIndexPath!.row] = Double(cell!.pointsPossibleTextField.text!)
        
        /*
        for i in 0..<pointsPossible.count
        {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! ClassCalculatorPercentagesCustomTableViewCell
            pointsRecieved[i] = Double(cell.pointsRecievedTextField.text!)
            pointsPossible[i] = Double(cell.pointsPossibleTextField.text!)
        }
         */
        //tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(pointsRecieved.count != pointsPossible.count)
        {
            fatalError("aaaaaaa")
        }
        return pointsPossible.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCalculatorPointsCellReuseIdentifier") as! ClassCalculatorPointsCustomTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.pointsRecievedTextField.delegate = self
        cell.pointsPossibleTextField.delegate = self
        
        if pointsRecieved[indexPath.row] != nil
        {
            cell.pointsRecievedTextField.text = removeDecimal(String(pointsRecieved[indexPath.row]!))
        }
        else
        {
            cell.pointsRecievedTextField.text = ""
        }
        
        if pointsPossible[indexPath.row] != nil
        {
            cell.pointsPossibleTextField.text = removeDecimal(String(pointsPossible[indexPath.row]!))
        }
        else
        {
            cell.pointsPossibleTextField.text = ""
        }
        
        return cell
    }
    
    @IBAction func addGradeButton()
    {
        pointsRecieved.append(nil)
        pointsPossible.append(nil)
        tableView.reloadData()
    }
    
    @IBAction func calculateButton()
    {
        var totalPointsRecieved:Double = 0
        var totalPointsPossible:Double = 0
        var i=0;while i<pointsPossible.count
        {
            totalPointsRecieved += (pointsRecieved[i] ?? 0)
            totalPointsPossible += (pointsPossible[i] ?? 0)
    i+=1}
        if(totalPointsPossible <= 0)
        {
            displayAlert("Error","Please enter your grades")
            return
        }
        let raw = totalPointsRecieved/totalPointsPossible*100
        let twoDecimal = removeDecimal(String(round(raw*10000)/10000))
        let fullRound = removeDecimal(String(round(raw)))
        displayAlert(fullRound+"%","Unrounded: "+twoDecimal+"%")
    }
    
    
}
extension UIViewController
{
    func removeDecimal(_ str:String) -> String
    {
        if(str.count>=2 && str[str.count-2] == "." && str[str.count-1] == "0")
        {
            return String(str.dropLast(2))
        }
        return str
    }
}


extension String {
    subscript (characterIndex: Int) -> Character {
        return self[index(startIndex, offsetBy: characterIndex)]
    }
}
