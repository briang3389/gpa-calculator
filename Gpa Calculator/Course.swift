//
//  Course.swift
//  Gpa Calculator
//
//  Created by Brian on 4/7/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class Course: NSObject, NSCoding
{
    static let noLevel = 0, collegePrep = 1, accelerated = 2, honnors = 3, advancedPlacement = 4
    //static let quarterYear = 1.25, halfYear = 2.5, fullYear = 5.0, fullYearWithLab = 6.0
    static let creditsOptions = [1.25, 2.5, 5.0, 6.0]
    
    var name:String
    var grade:Int
    var credits:Double
    var level:Int
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(grade, forKey: "grade")
        aCoder.encode(credits, forKey: "credits")
        aCoder.encode(level, forKey: "level")
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        let grade = aDecoder.decodeInteger(forKey: "grade") //as? Int ?? 0
        let credits = aDecoder.decodeDouble(forKey: "credits") //as? Double ?? 5.0
        let level = aDecoder.decodeInteger(forKey: "level") //as? Int ?? 0
        self.init(name: name, grade: grade, credits: credits, level: level)
    }
    
    init(name:String, grade:Int, credits:Double, level:Int)
    {
        self.name = name
        self.grade = grade
        self.credits = credits
        self.level = level
    }
}
