//
//  DataService.swift
//  breakpoint
//
//  Created by Jamil Jalal on 12/27/18.
//  Copyright © 2018 Jamil Jalal. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = Database.database().reference()// Database base url

class DataService {
    
    static let instance = DataService() // Make it accesssible in any other classes.
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USER
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
