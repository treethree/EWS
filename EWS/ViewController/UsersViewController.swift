//
//  UsersViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import TWMessageBarManager
import SVProgressHUD

class UsersViewController: UIViewController {
    var ref: DatabaseReference!
    var users = [UserModel]()
    var userID = [String]()
    var userimg = [UIImage]()
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        getAllUsers()
        tblView.reloadData()
        tblView.backgroundColor = .clear
        tblView.showsVerticalScrollIndicator = false
        tblView.bounces = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func addFriendBtnClick(_ sender: UIButton) {
        FirebaseApiHandler.sharedInstance.addFriend(friendId: users[sender.tag].uid) { (error) in
            if error == nil{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Add friend", description: "You successfully add a new friend!", type: .success)
            }else{
                print(error)
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error Add friend", description: "Error happen when add a new friend!", type: .error)
            }
        }
        
        
    }
    
    func getAllUsers(){
        SVProgressHUD.show()
        FirebaseApiHandler.sharedInstance.getUsers { (usermodel) in
            self.users = usermodel!
            DispatchQueue.main.async {
                self.tblView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    //get image from firebase storage
    func getUserImage(){
        for uid in userID{
            let imagename = "UserImage/\(uid).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imagename)
            storageRef.getData(maxSize: 1*300*300) { (data, error) in
                let img = UIImage(data: data!)
                self.userimg.append(img!)
                print(self.userimg)
            }
        }
    }
}

extension UsersViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "usersCell") as? UsersTableViewCell
        cell?.layer.cornerRadius = 10.0
        let userObj = users[indexPath.row]
        cell?.fnameLbl.text = "First Name: \(userObj.fname)"
        cell?.lNameLbl.text = "Last Name: \(userObj.lname)"
        SVProgressHUD.show()
        FirebaseApiHandler.sharedInstance.getUserImg(id: users[indexPath.row].uid) { (data, error) in
            if data != nil{
                cell?.imgView.image = UIImage(data : data!)
                cell?.imgView.roundedImage()
                SVProgressHUD.dismiss()
            }else{
                print(error)
                SVProgressHUD.dismiss()
            }
        }
        cell?.addFriendLbl.tag = indexPath.row
        
        return cell!
    }
    
    
}
