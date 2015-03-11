//
//  ProfileViewController.swift
//  ForeignChat
//
//  Created by Tonny Hao on 2/20/15.
//  Copyright (c) 2015 Tonny Hao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: PFImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var imageButton: UIButton!

    var currentUser:FCUser?
    var pictureFile:PFFile?
    var thumbnailFile:PFFile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentUser = FCUser.currentUser() {
            self.loadUser()
        } else {
            Utilities.loginUser(self)
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.layer.masksToBounds = true;
        imageButton.layer.cornerRadius = userImageView.frame.size.width / 2;
        imageButton.layer.masksToBounds = true;
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadUser() {
        var fcUser = FCUser.currentUser()
        var query = FCUser.query()
        query.getObjectInBackgroundWithId(fcUser.objectId) {
            (pfObject: PFObject!, error: NSError!) -> Void in
            if pfObject != nil {
                self.currentUser = pfObject as FCUser!
                var gender = self.currentUser?.gender
                println("name: \(self.currentUser?.gender)") //nil
                self.nameField.text = self.currentUser?.fullName as String?
                if self.self.currentUser?.picture != nil {
                    var data = self.currentUser?.thumbnail?.getData()
                    if data != nil {
                        var image = UIImage(data: data!)
                        image = Images.resizeImage(image!, width: 60, height: 60)!
                        self.userImageView.image = image
                    }
                }
            } else {
                println(error)
            }
        }

        
    }
    
    func saveUser() {
        let fullName = nameField.text
        if countElements(fullName) > 0 {
//            var user = PFUser.currentUser()
//            user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
//                if error == nil {
//                    ProgressHUD.showSuccess("Saved")
//                } else {
//                    ProgressHUD.showError("Network error")
//                }
//            })
            if currentUser != nil {
                currentUser!.picture = pictureFile
                currentUser!.thumbnail = thumbnailFile
                currentUser!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
                    if error != nil {
                        ProgressHUD.showError("Network error")
                    }
                }
            }
            
        } else {
            ProgressHUD.showError("Name field must not be empty")
        }
    }
    
    // MARK: - User actions
    
    func cleanup() {
        userImageView.image = UIImage(named: "profile_blank")
        nameField.text = nil;
    }
    
    func logout() {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Log out")
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        self.logout()
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            PFUser.logOut()
            PushNotication.parsePushUserResign()
            Utilities.postNotification(NOTIFICATION_USER_LOGGED_OUT)
            self.cleanup()
            Utilities.loginUser(self)
        }
    }
    
    @IBAction func photoButtonPressed(sender: UIButton) {
        Camera.shouldStartPhotoLibrary(self, canEdit: true)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        self.dismissKeyboard()
        self.saveUser()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as UIImage
        if image.size.width > 280 {
            image = Images.resizeImage(image, width: 280, height: 280)!
        }
        
        pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
        pictureFile?.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        userImageView.image = image
        
        if image.size.width > 60 {
            image = Images.resizeImage(image, width: 60, height: 60)!
        }
        
        thumbnailFile = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6))
        thumbnailFile?.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
//        var user = PFUser.currentUser()
//        user[PF_USER_PICTURE] = pictureFile
//        user[PF_USER_THUMBNAIL] = thumbnailFile
//        user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//            if error != nil {
//                ProgressHUD.showError("Network error")
//            }
//        }
        
        if currentUser != nil {
            currentUser!.picture = pictureFile!
            currentUser!.thumbnail = thumbnailFile!
            currentUser!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
                if error != nil {
                    ProgressHUD.showError("Network error")
                }
            }
        }

        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
