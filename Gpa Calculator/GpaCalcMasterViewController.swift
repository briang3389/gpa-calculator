//
//  GpaCalcMasterViewController.swift
//  Gpa Calculator
//
//  Created by Brian on 3/30/20.
//  Copyright © 2020 Brian. All rights reserved.
//


import UIKit

var indexToDelete = -1
let defaultA:[[Double]] = [
[4,      4.5,    4.9,    5.3],
[3.75,   4.22,   4.59,   4.97],
[3.5,    3.94,   4.29,   4.64],
[3.25,   3.66,   3.98,   4.31],
[3,      3.38,   3.68,   3.98],
[2.75,   3.09,   3.37,   3.64],
[2.5,    2.81,   3.06,   3.31],
[2.25,   2.53,   2.76,   2.98],
[1.75,   1.97,   2.14,   2.32],
[1.5,    1.69,   1.84,   1.99],
[1.25,   1.41,   1.53,   1.66],
[0,      0,      0,      0]
]
var a:[[Double]] = []

class GpaCalcMasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prevCreditsTextField: UITextField!
    @IBOutlet weak var prevUnweightedGpaTextField: UITextField!
    @IBOutlet weak var prevWeightedGpaTextField: UITextField!
    
    
    var courses: [Course] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        load()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        prevUnweightedGpaTextField.delegate = self
        prevWeightedGpaTextField.delegate = self
        prevCreditsTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        if UserDefaults.standard.bool(forKey: "tutorialShown") == false
        {
            displayAlert("Welcome", "Enter your previous GPA and credits at the top of the screen. Freshman should leave these blank. Add your first class with the \"Add Class\" button.")
            UserDefaults.standard.set(true, forKey: "tutorialShown")
        }
    }
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if prevWeightedGpaTextField.text != "" && Double(prevWeightedGpaTextField.text!) == nil
        {
            prevWeightedGpaTextField.text = ""
        }
        if prevUnweightedGpaTextField.text != "" && Double(prevUnweightedGpaTextField.text!) == nil
        {
            prevUnweightedGpaTextField.text = ""
        }
        if prevCreditsTextField.text != "" && Double(prevCreditsTextField.text!) == nil
        {
            prevCreditsTextField.text = ""
        }
        save()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if indexToDelete >= 0
        {
            courses.remove(at: indexToDelete)
            indexToDelete = -1
            var i=0; while i<courses.count
            {
                if courses[i].name.prefix(6) == "Class "
                {
                    courses[i].name = "Class \(i+1)"
                }
            i+=1
            }
        }
        if let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        tableView.reloadData()
        save()
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        /*
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? GpaCalcDetailViewController
        {
            vc.course = courses[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
         */
        
        //activeIndex = indexPath.row
        //performSegue(withIdentifier: "segue", sender: self)
        /*
        let alertController = UIAlertController(title: "Hint", message: "you selected row \(indexPath.row)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        */
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToDetailView"
        {
            let detailVC:GpaCalcDetailViewController? = segue.destination as? GpaCalcDetailViewController
            let cell:GpaCalcCustomTableViewCell? = sender as? GpaCalcCustomTableViewCell
            if cell != nil && detailVC != nil
            {
                detailVC!.course = courses[tableView.indexPathForSelectedRow!.row]
                detailVC!.index = tableView.indexPathForSelectedRow!.row
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return courses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! GpaCalcCustomTableViewCell
        /*
        switch(courses[indexPath.row].level)
        {
        case Course.noLevel:
            cell.classTitleLabel.text = "\(courses[indexPath.row].name) (\(courses[indexPath.row].credits) credits)"
        case Course.collegePrep:
            cell.classTitleLabel.text = "\(courses[indexPath.row].name) CP (\(courses[indexPath.row].credits) credits)"
        case Course.accelerated:
            cell.classTitleLabel.text = "\(courses[indexPath.row].name) A (\(courses[indexPath.row].credits) credits)"
        case Course.honnors:
            cell.classTitleLabel.text = "\(courses[indexPath.row].name) H (\(courses[indexPath.row].credits) credits)"
        case Course.advancedPlacement:
            cell.classTitleLabel.text = "AP \(courses[indexPath.row].name) (\(courses[indexPath.row].credits) credits)"
        default:
            fatalError("1")
        }
        */
        cell.classTitleLabel.text = "\(courses[indexPath.row].name)"
        cell.gradeLabel.text = "\(courses[indexPath.row].grade)%"
        
        return cell
    }
    
    @IBAction func addClass()
    {
        courses.append(Course(name: "", grade: 0, credits: 5, level: Course.noLevel))
        courses.last!.name = "Class \(courses.count)"
        tableView.reloadData()
        save()
    }
    
    
    @IBAction func calculateButton()
    {
        if courses.count == 0
        {
            displayAlert("Error", "Grades are required to calculate GPA")
            return
        }
        if !((prevUnweightedGpaTextField.text! == "" && prevWeightedGpaTextField.text! == "" && prevCreditsTextField.text! == "")||(prevUnweightedGpaTextField.text! != "" && prevWeightedGpaTextField.text! != "" && prevCreditsTextField.text! != ""))
        {
            displayAlert("Error", "Previous GPAs and Previous Credits have to either all be filled in or all be blank")
            return
        }
        
        let prevUnweightedGpa = Double(prevUnweightedGpaTextField.text!) ?? 0
        let prevWeightedGpa = Double(prevWeightedGpaTextField.text!) ?? 0
        let prevCredits = Double(prevCreditsTextField.text!) ?? 0
        
        var totalCredits:Double = prevCredits
        for i in courses
        {
            totalCredits += i.credits
        }
        
        /*
        if totalCredits == 0
        {
            let alertController = UIAlertController(title: "Error", message: "Enter the number of credits for each class", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        */
        
        var t:Double = prevUnweightedGpa * prevCredits
        for i in courses
        {
            let g:Int = i.grade
            let v:Double = (g>=95 ? a[0][0] : (g>=90 ? a[1][0] : (g>=87 ? a[2][0] : (g>=83 ? a[3][0] : (g>=80 ? a[4][0] : (g>=77 ? a[5][0] : (g>=73 ? a[6][0] : (g>=70 ? a[7][0] : (g>=67 ? a[8][0] : (g>=63 ? a[9][0] : (g>=60 ? a[10][0] : a[11][0])))))))))))
            t += v * i.credits
        }
        let unweightedGpa:Double = round(t/totalCredits*10000)/10000
        
        t = prevWeightedGpa * prevCredits
        for i in courses
        {
            let g:Int = i.grade
            let lev:Int = i.level
            let v:Double = (g>=95 ? a[0][lev] : (g>=90 ? a[1][lev] : (g>=87 ? a[2][lev] : (g>=83 ? a[3][lev] : (g>=80 ? a[4][lev] : (g>=77 ? a[5][lev] : (g>=73 ? a[6][lev] : (g>=70 ? a[7][lev] : (g>=67 ? a[8][lev] : (g>=63 ? a[9][lev] : (g>=60 ? a[10][lev] : a[11][lev])))))))))))
            t += v * i.credits
        }
        let weightedGpa:Double = round(t/totalCredits*10000)/10000
        
        displayAlert("GPA", "Unweighted:\t\(unweightedGpa)\nWeighted:\t\(weightedGpa)")
    }
    func save()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: courses), forKey: "courses")
        UserDefaults.standard.set(prevCreditsTextField.text!, forKey: "prevCredits")
        UserDefaults.standard.set(prevUnweightedGpaTextField.text!, forKey: "prevUnweightedGpa")
        UserDefaults.standard.set(prevWeightedGpaTextField.text!, forKey: "prevWeightedGpa")
    }
    func load()
    {
        let coursesData = UserDefaults.standard.object(forKey: "courses") as? NSData
        if let coursesData = coursesData {
            let courses = NSKeyedUnarchiver.unarchiveObject(with: coursesData as Data) as? [Course]
            if let courses = courses {
                self.courses = courses
            }
        }
        
        prevCreditsTextField.text = UserDefaults.standard.string(forKey: "prevCredits") ?? ""
        prevUnweightedGpaTextField.text = UserDefaults.standard.string(forKey: "prevUnweightedGpa") ?? ""
        prevWeightedGpaTextField.text = UserDefaults.standard.string(forKey: "prevWeightedGpa") ?? ""
        
        
        a = UserDefaults.standard.object(forKey: "a") as? [[Double]] ?? defaultA
    }
}
extension UIViewController
{
    func displayAlert(_ title:String, _ message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

