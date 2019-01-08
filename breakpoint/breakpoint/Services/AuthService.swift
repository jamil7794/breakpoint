//
//  AuthService.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/2/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) ->()){
        
        //Auth is a built in function in FireBase
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            // If the user already exists return save in user else  userCreationComplete(false, error) = error
            
            let userData = ["provider": user.user.providerID, "email": user.user.email]
            DataService.instance.createDBUser(uid: user.user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true,nil)
        }
        
     
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginCreationComplete: @escaping (_ status: Bool, _ error: Error?) ->()){
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil{
                loginCreationComplete(false, error)
                return
            }
            loginCreationComplete(true,nil)
        }
    }
}
