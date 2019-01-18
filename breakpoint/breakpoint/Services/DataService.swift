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
    
    var STORAGE : StorageReference {
       return Storage.storage().reference().child("images") // by default the Firebase should have one bucket, To have more, I need to updgrade it to premium
    }
    
   // var profilePicture = "profilePicture\(Auth.auth().currentUser!.uid).jpg"
    
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
    
    func uploadProfilePicture(filename: String, image: UIImage?, handler: @escaping(_ success: Bool) -> ()){
        if image != nil {
            guard let imageData = image!.jpegData(compressionQuality: 1) else {return}
            let uploadImgReference = STORAGE.child(filename)
            
            let uploadTask = uploadImgReference.putData(imageData)
            uploadTask.observe(.progress) { (snapShot) in
                
                print("Uploading")
                print(snapShot.progress ?? "Done")
            }
            uploadTask.resume()
            uploadTask.pause()
            handler(true)
        }
    }
    
    func downloadProfilePicture(handler: @escaping(_ image: UIImage, _ success: Bool) -> ()){
        var image = UIImage()
        let profilePicture = "profilePicture\(Auth.auth().currentUser!.uid).jpg"
            let downloadImgReference = STORAGE.child(profilePicture)
            print(downloadImgReference)
            let downloadTask = downloadImgReference.getData(maxSize: 1024 * 1024 * 12) {(data, error) in
                if let imgdata = data {
                    image = UIImage(data: imgdata)!
                    handler(image,true)
                }else{
                    print("No Data")
                }
                print("No Error")
            }

            downloadTask.observe(.progress) { (snapShot) in
                print("Downloading")
                print(snapShot.progress ?? "Done")
            }

            downloadTask.resume()
            downloadTask.pause()
            handler(image, false)
    }

    
    func uploadPosts(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()){
        
        if(groupKey != nil){
            REF_GROUPS.child(groupKey!).child("message").childByAutoId().updateChildValues(["content" : message, "senderId":uid])
            // groupkey -> create message -> updateChildByAutodId -> content and message
            sendComplete(true)
        }else{
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            
           // REF_FEED.childByAutoId().updateChildValues(["content": message])
            sendComplete(true)
        }
        
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()){
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("message").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessagesnashot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for groupMessage in groupMessagesnashot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupmessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupmessage)
            }
            
            handler(groupMessageArray)
        }
    }
    
    
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()){
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapShot) in
            // we gonna watch all the user
            
            guard let userSnapshot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getEmailsForGroup(group: Group, handler: @escaping (_ emailArray: [String]) -> ()){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIDs(forUsername usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            var idArray = [String]()
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email){
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()){
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapShot) in
            guard let groupSnapShot = groupSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapShot{
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!){
                    //if this contatins me, then go ahead and do something. Get all the groups where it has me on it
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(title: title, description: description, key: group.key, memberCount: memberArray.count, members: memberArray)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    

    
 
}
