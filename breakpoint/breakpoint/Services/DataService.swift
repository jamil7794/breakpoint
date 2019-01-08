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
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()){
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            // Get all the values from REF_FEED and save it to geedMessageSnapshot
            
            guard let feedMessageSnapsho = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for message in feedMessageSnapsho {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                
                let message = Message(content: content, senderId: senderId)
                
                messageArray.append(message)
            }
            
            handler(messageArray)
        }
        
    }
    
    func getUserName(forUID uid: String, handler: @escaping (_ username: String) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapshot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    func uploadPosts(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()){
        
        if(groupKey != nil){
            
        }else{
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            
           // REF_FEED.childByAutoId().updateChildValues(["content": message])
            sendComplete(true)
        }
        
    }
}
