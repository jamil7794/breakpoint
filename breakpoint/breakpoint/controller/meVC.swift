//
//  meVC.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/3/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit
import Firebase

class meVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var image : UIImage?
    var loaded = false
    var myFeeds = [String]()
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.height/2
        self.profileImage.image = image

        DataService.instance.downloadProfilePicture { (profileImage, success) in
            if success {
                if (self.profileImage!.image != nil) {
                    self.profileImage.image = profileImage
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }

            }else{
                self.profileImage.image = UIImage(named: "defaultProfileImage")
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
            }
        }
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // it works before viewdidload and then its going to update
        let CURRENT_LOGER = Auth.auth().currentUser?.uid
        self.emailLbl.text = Auth.auth().currentUser?.email
        if loaded {
            DataService.instance.downloadProfilePicture { (profileImage, success) in
                if success {
                        if (self.profileImage!.image != nil) {
                            self.profileImage.image = self.image
                        }
                    }else{
                        self.profileImage.image = UIImage(named: "defaultProfileImage")
                }
            }
            loaded = false
        }
        
        if CURRENT_LOGER == Auth.auth().currentUser?.uid{
            DataService.instance.downloadProfilePicture { (profileImage, success) in
                if success {
                    if (self.profileImage!.image != nil) {
                        self.profileImage.image = profileImage
                        self.activityIndicator.stopAnimating()
                        
                    }
                }else{
                    self.profileImage.image = UIImage(named: "defaultProfileImage")
                }
            }
        }
        DataService.instance.getAllMessagesForUID(uid: (Auth.auth().currentUser?.uid)!) { (messages) in
            
            self.myFeeds = messages
            self.tableView.reloadData()
        }
        
        DataService.instance.getAllMessagesForUIDinGroups(uid: (Auth.auth().currentUser?.uid)!) { (message) in
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        let logoutPop = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout!", style: .destructive) { (buttonTapped) in
            do{
                try Auth.auth().signOut()
                let AuthVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(AuthVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        
        logoutPop.addAction(logoutAction)
        present(logoutPop, animated: true, completion: nil)
    }
    
    @IBAction func changePictureWasPressed(_ sender: Any) {
        let imageOrCamera = UIAlertController(title: "Upload Picture", message: "Tap Source Type", preferredStyle: .actionSheet)

        let imageOrCameraAction1 = UIAlertAction(title: "Photo Library", style: .destructive) { (buttonTapped) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }

        let imageOrCameraAction2 = UIAlertAction(title: "Camera", style: .destructive) { (buttonTapped) in
            imageOrCamera.dismiss(animated: true, completion: nil)
        }

        let imageOrCameraAction3 = UIAlertAction(title: "Cancel", style: .cancel) { (buttonTapped) in
            imageOrCamera.dismiss(animated: true, completion: nil)
        }

        imageOrCamera.addAction(imageOrCameraAction1)
        imageOrCamera.addAction(imageOrCameraAction2)
        imageOrCamera.addAction(imageOrCameraAction3)
        present(imageOrCamera, animated: true, completion: nil)
 

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            var im = UIImage()
            
            im = image
            let filename = "profilePicture\(Auth.auth().currentUser!.uid).jpg"
            //profileImage.image = im.image
            DataService.instance.uploadProfilePicture(filename: filename, image: im) { (success) in
                if success {
                    self.image = im
                    self.profileImage.image = im
                    print("Uploaded")
                    self.loaded = true
                }
            }
            
            
            self.profileImage.image = im
            
        }else{
            print("there was an error")
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension meVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myFeedCell") as? myFeedCell else {return UITableViewCell()}
        
        let mess = myFeeds[indexPath.row]
        
        cell.configureCell(feed: mess)
        return cell
        
    }


}
