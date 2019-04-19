//
//  ChatViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/16/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var colView: UICollectionView!
    
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLbl: UILabel!
    
    var singleFriendInfo : UserModel?
    var chatInfo = [ChatInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChatConversation()
        friendImageView.image = singleFriendInfo?.image
        friendImageView.roundedImage()
        friendNameLbl.text = "\(singleFriendInfo!.fname)  \(singleFriendInfo!.lname)"
    }
    
    func addRow(_ cInfo : ChatInfo){
        chatInfo.append(cInfo)
    }
    
    func getChatConversation(){
        FirebaseApiHandler.sharedInstance.getConversation(friendID: singleFriendInfo!.uid) { (chatInfoArr) in
            if chatInfoArr != nil{
                self.chatInfo = chatInfoArr!
                self.chatInfo.sort(by: >)
                //DispatchQueue.main.async {
                    self.colView.reloadData()
                //}
            }else{
                print("error")
            }
        }
    }
    
    @IBAction func sendMessageBtnClick(_ sender: UIButton) {
        FirebaseApiHandler.sharedInstance.sendText(friendID: singleFriendInfo!.uid, msg: txtView.text) { (error) in
            if error == nil{
                print("Successfully send text message!")
            }else{
                print(error)
            }
        }
        //todo: need refresh collection view when button click
        getChatConversation()
        colView.reloadData()
    }
    
    @IBAction func hideChatBtnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ChatViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as? ChatCollectionViewCell
        cell?.receiverLbl.layer.masksToBounds = true
        cell?.receiverLbl.layer.cornerRadius = 5.0
        cell?.senderLbl.layer.masksToBounds = true
        cell?.senderLbl.layer.cornerRadius = 5.0
        
        let chatObj = chatInfo[indexPath.row]
        if chatObj.receiverID != singleFriendInfo?.uid{
            //set friend's text label
            cell?.receiverLbl.text = chatObj.message
            cell?.senderLbl.isHidden = true
        }else{
            cell?.senderLbl.text = chatObj.message
            cell?.receiverLbl.isHidden = true
        }
        
        return cell!
    }
    
    
}
