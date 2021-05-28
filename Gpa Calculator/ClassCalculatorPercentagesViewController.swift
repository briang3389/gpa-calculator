//
//  ClassCalculatorPercentagesViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 5/13/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

var nextCategoryId:Int = 0

class ClassCalculatorPercentagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ModalHandler {
    @IBOutlet weak var tableView: UITableView!
    
    var categories = Categories()
    
    var pointsRecieved:[Double?] = [nil]
    var pointsPossible:[Double?] = [nil]
    var category:[Int?] = [nil] //stores ids
    
    @IBAction func selectCategoryButtonPressed(_ sender: UIButton)
    {
        /*
        let cell = sender.superview!.superview as! ClassCalculatorPercentagesCustomTableViewCell
        guard let indexPath = tableView.indexPath(for: cell)
        else
        {
            print("err")
            return
        }
         */
        //print(indexPath.row)
        let index = sender.tag
        
        if(categories.categoryNames.count == 0)
        {
            displayAlert("Error", "There needs to be at least one category in order to select a category. Add a category by tapping the \"Categories\" button at the top of the screen")
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for i in 0..<categories.categoryNames.count
        {
            alertController.addAction(UIAlertAction(title: categories.categoryNames[i], style: .default, handler: { action in self.changeCategory(index, i)}))
            //print(i)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func changeCategory(_ gradeIndex:Int, _ categoryIndex:Int)
    {
        //print(categoryIndex)
        category[gradeIndex] = categories.getIdByIndex(categoryIndex)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextCategoryId = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        //setupViewResizerOnKeyboardShown()
        
        //categories.categoryIds.append(0)
        //categories.categoryNames.append("Test")
        //categories.categoryPercentages.append(20.0)
        
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
        //print("ending editing")
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = tableView.cellForRow(at: textFieldIndexPath!) as? ClassCalculatorPercentagesCustomTableViewCell
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
        //print("reloading data")
        //tableView.reloadData()
    }
    
    /*
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.tableView.contentInset.bottom = 100
        return true
    }
    */
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCalculatorPercentagesCellReuseIdentifier") as! ClassCalculatorPercentagesCustomTableViewCell
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
        
        let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
        var buttonText:String!
        if category[indexPath.row] != nil
        {
            let categoryIndex = categories.getIndexById(category[indexPath.row]!)
            if categoryIndex == -1
            {
                buttonText = "Select Category..."
                //category[indexPath.row] = nil
            }
            else
            {
                buttonText = categories.categoryNames[categoryIndex]
            }
            
        }
        else
        {
            buttonText = "Select Category..."
        }
        for controlState in controlStates {
            cell.selectCategoryButton.setTitle(buttonText, for: controlState)
        }
        
        cell.selectCategoryButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func addGradeButton()
    {
        pointsRecieved.append(nil)
        pointsPossible.append(nil)
        category.append(nil)
        tableView.reloadData()
    }
    
    @IBAction func calculateButton()
    {
        var array:[Double?] = []
        
        for i in 0..<categories.categoryNames.count
        {
            var totalPointsRecieved:Double = 0
            var totalPointsPossible:Double = 0
            for j in 0..<pointsPossible.count
            {
                if(category[j] == categories.categoryIds[i])
                {
                    totalPointsRecieved += (pointsRecieved[j] ?? 0)
                    totalPointsPossible += (pointsPossible[j] ?? 0)
                }
            }
            if(totalPointsPossible == 0)
            {
                array.append(nil)
                continue
            }
            array.append(totalPointsRecieved / totalPointsPossible * Double(categories.categoryPercentages[i]))
        }
        
        var raw:Double = 0
        var sumOfActiveCategories:Double = 0
        for i in 0..<array.count
        {
            if(array[i] != nil)
            {
                raw += array[i]!
                sumOfActiveCategories += Double(categories.categoryPercentages[i])
            }
        }
        if(sumOfActiveCategories == 0)
        {
            displayAlert("Error","Please enter your grades, set up the categories, and choose the corresponding category for each grade")
            return
        }
        raw *= (100.0 / sumOfActiveCategories)
        
        let twoDecimal = removeDecimal(String(round(raw*10000)/10000))
        let fullRound = removeDecimal(String(round(raw)))
        displayAlert(fullRound+"%","Unrounded: "+twoDecimal+"%")
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToCategoryEditor"
        {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! EditCategoriesViewController
            targetController.categories=self.categories
            
            targetController.delegate = self
        }
    }

    func modalDismissed()
    {
        tableView.reloadData()
    }
}

protocol ModalHandler {
    func modalDismissed()
}
/*
extension UIViewController
{
    func setupViewResizerOnKeyboardShown()
    {
        NotificationCenter.default.addObserver(self,
        selector: #selector(UIViewController.keyboardWillShowForResizing),
        name: UIResponder.keyboardDidShowNotification,
        object: nil)
        NotificationCenter.default.addObserver(self,
        selector: #selector(UIViewController.keyboardWillHideForResizing),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
    }
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height + 55)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height - 55)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
}*/
