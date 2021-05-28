//
//  GpaCalcSettingsViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 5/22/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class GpaCalcSettingsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func saveButton(_ sender: Any)
    {
        if(saveToArray())
        {
            saveToStorage()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func defaultsButton(_ sender: Any)
    {
        //ask user first
        let alertController = UIAlertController(title: "Restore Default Settings?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in self.restoreDefaults()}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func restoreDefaults()
    {
        a=defaultA
        saveToStorage()
        load()
    }
    
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        //use these for content insets only
        //use save button for saving
        //nvm dont need these
        
    }
    
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
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
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - safeAreaBottomInset, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func load()
    {
        for i in 0..<48
        {
            let theTextField = self.view.viewWithTag(i+1) as! UITextField
            theTextField.text = String(a[i/4][i%4])
        }
    }
    
    func saveToArray() -> Bool
    {
        for i in 0..<48
        {
            let theTextField = self.view.viewWithTag(i+1) as! UITextField
            let asdf = Double(theTextField.text!)
            if asdf != nil
            {
                a[i/4][i%4] = asdf!
            }
            else
            {
                displayAlert("Error", "\(theTextField.text!) is an invalid number")
                return false
            }
            
        }
        return true
    }
    
    func saveToStorage()
    {
        UserDefaults.standard.set(a, forKey: "a")
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
