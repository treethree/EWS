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
    var users = [[String : Any]]()
    var userID = [String]()
    var userimg = [UIImage]()
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getAllUsers()
        getUserImage()
    }
    //get all users
    func getAllUsers(){
            self.ref.child("User").observeSingleEvent(of: .value) { (snapshot) in
                if let snap = snapshot.value as? [String:Any]{
                for record in snap{
                    if let uInfo = record.value as? [String: Any]{
                        self.users.append(uInfo)
                        
                        self.tblView.reloadData()
                        //print(self.users)
                        }
                    
                    self.userID.append(record.key)
                    self.tblView.reloadData()
                    //print(self.userID)
                    }
                    
                }
            }
    }
    
    //get image from firebase storage
    func getUserImage(){
        //if let user = Auth.auth().currentUser{
        for uid in userID{
            let imagename = "UserImage/\(uid).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imagename)
            storageRef.getData(maxSize: 1*300*300) { (data, error) in
                let img = UIImage(data: data!)
                //print(img)
                self.userimg.append(img!)
                print(self.userimg)
            }
        }
        //}
    }
}

extension UsersViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "usersCell") as? UsersTableViewCell
        let userObj = users[indexPath.row]
        let uidObj = userID[indexPath.row]
        cell?.fnameLbl.text = "First Name: \(userObj["FirstName"]!)"
        cell?.lNameLbl.text = "Last Name: \(userObj["LastName"]!)"
        //cell?.imgView.image = getUserImage(uid: uidObj)
        return cell!
    }
    
    
}
