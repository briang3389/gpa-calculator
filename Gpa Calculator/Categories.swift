//
//  Categories.swift
//  Gpa Calculator
//
//  Created by Brian on 5/15/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class Categories
{
    var categoryNames:[String] = []
    var categoryPercentages:[Int] = []
    var categoryIds:[Int] = []
    
    func getIndexById(_ id:Int) -> Int
    {
        return categoryIds.firstIndex(of: id) ?? -1
    }
    func getIdByIndex(_ index:Int) -> Int
    {
        return categoryIds[index]
    }
}
