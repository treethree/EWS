//
//  FriendsViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import TWMessageBarManager

class FriendsViewController: UIViewController {

    var users = [UserModel]()

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.backgroundColor = .clear
        tblView.showsVerticalScrollIndicator = false
        tblView.bounces = false
        getFriend()
    }
    
    func getFriend(){
        FirebaseApiHandler.sharedInstance.getFriends { (friendArr) in
            if friendArr != nil{
                self.users = friendArr!
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    @IBAction func deleteFriendBtnClick(_ sender: UIButton) {
        FirebaseApiHandler.sharedInstance.removeFriend(friendId: users[sender.tag].uid) { (error) in
            print(error)
            self.users.remove(at: sender.tag)
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Delete friend", description: "You successfully delete a friend!", type: .success)
        }
    }
    
    @IBAction func refreshBtnClick(_ sender: UIButton) {
        getFriend()
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Refresh", description: "You successfully refresh friend list!", type: .success)
    }
    
}


extension FriendsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "friendsCell") as? FriendsTableViewCell
        let userObj = users[indexPath.row]
        cell?.fnameLbl.text = "First Name: \(userObj.fname)"
        cell?.lnameLbl.text = "Last Name: \(userObj.lname)"
        cell?.deleteBtnOutlet.tag = indexPath.row
        return cell!
    }
}
