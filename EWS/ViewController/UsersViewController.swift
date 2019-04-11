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

class UsersViewController: UIViewController {
    var ref: DatabaseReference!
    var users : [UserModel]?{
        didSet{
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
    //var users = [[String : Any]]()
    var userID = [String]()
    var userimg = [UIImage]()
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
//        FirebaseApiHandler.sharedInstance.getUsers { (users) in
//            print(users)
//        }
        //getAllUsers()
        getUserImage()
        
        tblView.backgroundColor = .clear
        tblView.showsVerticalScrollIndicator = false
        tblView.bounces = false
    }

    @IBAction func addFriendBtnClick(_ sender: UIButton) {
        
        //sender.tag
        
//        FirebaseApiHandler.sharedInstance.getUsers { (users) in
//            users
//        }
//        FirebaseApiHandler.sharedInstance.addFriend(friendId: users) { (error) in
//            print(error)
//        }
    }
    
    func getAllUsers(){
        FirebaseApiHandler.sharedInstance.getUsers { (usermodel) in
            self.users = usermodel
        }
    }
    
    //get all users
//    func getAllUsers(){
//            self.ref.child("User").observeSingleEvent(of: .value) { (snapshot) in
//                if let snap = snapshot.value as? [String:Any]{
//                for record in snap{
//                    if let uInfo = record.value as? [String: Any]{
//                        self.users.append(uInfo)
//
//                        self.tblView.reloadData()
//                        //print(self.users)
//                        }
//
//                    self.userID.append(record.key)
//                    self.tblView.reloadData()
//                    //print(self.userID)
//                    }
//
//                }
//            }
//    }
    
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
        return users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "usersCell") as? UsersTableViewCell
        let userObj = users![indexPath.row]
        //let uidObj = userID[indexPath.row]
//        cell?.fnameLbl.text = "First Name: \(userObj["FirstName"]!)"
//        cell?.lNameLbl.text = "Last Name: \(userObj["LastName"]!)"
        cell?.fnameLbl.text = "First Name: \(userObj.fname)"
        cell?.lNameLbl.text = "Last Name: \(userObj.lname)"
        //cell?.imgView.image = getUserImage(uid: uidObj)
        cell?.addFriendLbl.tag = indexPath.row
        return cell!
    }
    
    
}
