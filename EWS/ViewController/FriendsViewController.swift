//
//  FriendsViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class FriendsViewController: UIViewController {

    var users = [UserModel]()
    var singleFriend : UserModel?

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.backgroundColor = .clear
        tblView.showsVerticalScrollIndicator = false
        tblView.bounces = false
        getFriend()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        tblView.reloadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func getFriend(){
        SVProgressHUD.show()
        FirebaseApiHandler.sharedInstance.getFriends { (friendArr) in
            if friendArr != nil{
                self.users = friendArr!
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }else{
                print("error")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func chatBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        vc?.singleFriendInfo = singleFriend
        present(vc!, animated: true, completion: nil)
    }
    
    
    @IBAction func mapBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendsMapViewController")
        navigationController?.pushViewController(vc!, animated: true)
        //present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func deleteFriendBtnClick(_ sender: UIButton) {
        SVProgressHUD.show()
        FirebaseApiHandler.sharedInstance.removeFriend(friendId: users[sender.tag].uid) { (error) in
            if error == nil{
                self.users.remove(at: sender.tag)
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    SVProgressHUD.dismiss()
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Delete friend", description: "You successfully delete a friend!", type: .success)
                }
            }else{
                print(error)
                SVProgressHUD.dismiss()
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error deleting friend", description: "Error happen when delete a friend!", type: .error)
            }
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
        cell?.layer.cornerRadius = 10.0
        let userObj = users[indexPath.row]
        //bug here for multi friends
        singleFriend = users[indexPath.row]
        
        //chatBtnOutlet.tag = indexPath.row
        
        cell?.fnameLbl.text = "First Name: \(userObj.fname)"
        cell?.lnameLbl.text = "Last Name: \(userObj.lname)"
        cell?.deleteBtnOutlet.tag = indexPath.row
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
        return cell!
    }
}
