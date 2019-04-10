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
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getAllUsers()
        tblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    //get all users
    func getAllUsers(){
        
        ref.child("User").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
            for record in snap{
                if let uInfo = record.value as? [String: Any]{
                    self.users.append(uInfo)
                    print(self.users)
                    }
                }
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
        let userObj = users[indexPath.row]
        cell?.fnameLbl.text = "First Name: \(userObj["FirstName"]!)"
        cell?.lNameLbl.text = "Last Name: \(userObj["LastName"]!)"
        return cell!
    }
    
    
}
