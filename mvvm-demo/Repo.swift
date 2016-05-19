//
//  Repo.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RealmSwift

class Repo: Object {
    dynamic var id = 0;
    dynamic var full_name:String = "";
    dynamic var language:String? = ""
    
    override class func primaryKey() -> String? {
        return "id";
    }
}