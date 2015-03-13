//
//  ProfileViewController.swift
//  ForeignChat
//
//  Created by Tonny Hao on 2/20/15.
//  Copyright (c) 2015 Tonny Hao. All rights reserved.
//

import UIKit

private let kIconCellIndentifier  = "IconCellIndentifier"
private let kNormalCellIndentifier = "NormalCellIndentifier"


//let kAccountBGColor = UIColor(red: 243.0/255.0, green: 244.0/255.0, blue: 248.0/255.0, alpha: 1.0)
let kAccountBGColor =       UIColor.groupTableViewBackgroundColor()

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileTableView: UITableView!
    var userName: String? = nil
    var userIcon: UIImage? = nil

    var currentUser:FCUser?
    var pictureFile:PFFile?
    var thumbnailFile:PFFile?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kAccountBGColor
        self.profileTableView.backgroundColor = kAccountBGColor
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let currentUser = FCUser.currentUser() {
            self.loadUser()
        } else {
            Utilities.loginUser(self)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let currentUser = FCUser.currentUser() {
//            self.loadUser()
//        } else {
//            Utilities.loginUser(self)
//        }
//
//        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
//        userImageView.layer.masksToBounds = true;
//        imageButton.layer.cornerRadius = userImageView.frame.size.width / 2;
//        imageButton.layer.masksToBounds = true;
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        if section == 1{
            return ""
        }
        return nil
    }
    
    private let kUserIconViewTag = 1000
    private let kUserNameLabelTag = 1001
    
    
    private let kNormalCellIconTag = 1002
    private let kNormalCellLabelTag = 1003

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(kIconCellIndentifier) as UITableViewCell
            var userIcon = cell.viewWithTag(kUserIconViewTag)
            if self.userIcon != nil {
                (userIcon as PFImageView).image = self.userIcon
                (userIcon as PFImageView).layer.cornerRadius = 3
            }
            var userNameLable = cell.viewWithTag(kUserNameLabelTag)
            if  self.userName != nil {
                (userNameLable as UILabel).text = self.userName
            }
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(kNormalCellIndentifier) as UITableViewCell
        
            var textLable = cell.viewWithTag(kNormalCellLabelTag)
            var cellIcon = cell.viewWithTag(kNormalCellIconTag)

            if indexPath.row == 0 {
                (textLable as UILabel).text = "My Posts"
                var image = UIImage(named:"icon_posts")
                (cellIcon as PFImageView).image = image
       
            } else if indexPath.row == 1 {
                (textLable as UILabel).text = "My Videos"
                var image = UIImage(named:"icon_videos")
                (cellIcon as PFImageView).image = image


            }
        }
        cell.accessoryType =  .DisclosureIndicator
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 80
        }
        return 50
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 15
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    // MARK: - UITableViewDelegate
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
       
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
                self.userName = self.currentUser?.fullName as String?
                if self.self.currentUser?.picture != nil {
                    var data = self.currentUser?.thumbnail?.getData()
                    if data != nil {
                        var image = UIImage(data: data!)
                        self.userIcon = Images.resizeImage(image!, width: 60, height: 60)!
                    }
                }
                self.profileTableView.reloadData()
            } else {
                println(error)
            }
        }

        
    }
    
    func saveUser() {
//        let fullName = nameField.text
//        if countElements(fullName) > 0 {
//            if currentUser != nil {
//                currentUser!.picture = pictureFile
//                currentUser!.thumbnail = thumbnailFile
//                currentUser!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//                    if error != nil {
//                        ProgressHUD.showError("Network error")
//                    }
//                }
//            }
//            
//        } else {
//            ProgressHUD.showError("Name field must not be empty")
//        }
    }
    
    // MARK: - User actions
    
    func cleanup() {
//        userImageView.image = UIImage(named: "profile_blank")
//        nameField.text = nil;
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
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        var image = info[UIImagePickerControllerEditedImage] as UIImage
//        if image.size.width > 280 {
//            image = Images.resizeImage(image, width: 280, height: 280)!
//        }
//        
//        pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
//        pictureFile?.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//            if error != nil {
//                ProgressHUD.showError("Network error")
//            }
//        }
//        
//        userImageView.image = image
//        
//        if image.size.width > 60 {
//            image = Images.resizeImage(image, width: 60, height: 60)!
//        }
//        
//        thumbnailFile = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6))
//        thumbnailFile?.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//            if error != nil {
//                ProgressHUD.showError("Network error")
//            }
//        }
//        
////        var user = PFUser.currentUser()
////        user[PF_USER_PICTURE] = pictureFile
////        user[PF_USER_THUMBNAIL] = thumbnailFile
////        user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
////            if error != nil {
////                ProgressHUD.showError("Network error")
////            }
////        }
//        
//        if currentUser != nil {
//            currentUser!.picture = pictureFile!
//            currentUser!.thumbnail = thumbnailFile!
//            currentUser!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//                if error != nil {
//                    ProgressHUD.showError("Network error")
//                }
//            }
//        }
//
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }

}
