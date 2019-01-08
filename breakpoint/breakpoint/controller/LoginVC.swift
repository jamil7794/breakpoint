//
//  LoginVC.swift
//  breakpoint
//
//  Created by Jamil Jalal on 12/31/18.
//  Copyright © 2018 Jamil Jalal. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: InsertTextField!
    
    @IBOutlet weak var passwordField: InsertTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sinInBtnWasPressed(_ sender: Any) {
        
        if emailField.text != nil && passwordField != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else{
                   print(String(describing: error?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, error) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginCreationComplete: { (success, nil) in
                            print("Successfully registered user")
                            self.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        print(String(describing: error?.localizedDescription))
                    }
                })
            }
        }
    }
}
