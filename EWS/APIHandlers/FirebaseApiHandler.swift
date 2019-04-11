//
//  FirebaseApiHandler.swift
//  EWS
//
//  Created by SHILEI CUI on 4/10/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirebaseApiHandler: NSObject {
    static let sharedInstance = FirebaseApiHandler()
    private override init() {}
    var ref = Database.database().reference()
    
//    func getAllUsers(completionHandler : @escaping ([UserModel]?)->Void){
//        self.ref.child("User").observeSingleEvent(of: .value) { (snapshot) in
//            if let snap = snapshot.value as? [String:Any]{
//                for record in snap{
//                    if let uInfo = record.value as? [String: Any]{
//                        self.users.append(uInfo)
//                        
//                        self.tblView.reloadData()
//                        //print(self.users)
//                    }
//                    
//                    self.userID.append(record.key)
//                    self.tblView.reloadData()
//                    //print(self.userID)
//                }
//            }
//        }
//    }
    
    func addFriend(friendId: String, completionHandler: @escaping (Error?)->Void) {
        let user = Auth.auth().currentUser
        self.ref.child("User").child(user!.uid).child("FRIENDS").updateChildValues([friendId : "FriendID"]) { (error, ref) in
            completionHandler(error)
        }
    }
    
    func removeFriend(friendId: String, completionHandler: @escaping (Error?)->Void) {
        let user = Auth.auth().currentUser
        self.ref.child("User").child(user!.uid).child("FRIENDS").child(friendId).removeValue() { (error, ref) in
            completionHandler(error)
        }
    }
    
    func getFriends(completionHandler : @escaping ([UserModel]?)->Void) {
        let user = Auth.auth().currentUser
        var friendArray : [UserModel] = []
        let friendListdispatchGroup = DispatchGroup()
        self.ref.child("User").child(user!.uid).child("FRIENDS").observeSingleEvent(of: .value) { (snapshot) in
            if let friends = snapshot.value as? [String:Any] {
                for friend in friends {
                    friendListdispatchGroup.enter()
                    
                    self.ref.child("User").child(friend.key).observeSingleEvent(of: .value) { (friendSnapShot) in
                        guard let singleFriend = friendSnapShot.value as? Dictionary<String, Any> else {return}
                        
                        var userModel = UserModel(friend.key,info: friend.value as! [String : Any])
                                        

                        
                        self.getUserImg(id: userModel.uid, completionHandler: { (data, error) in
                            if error == nil && !(data == nil){
                                userModel.image = UIImage(data: data!)
                            }
                            friendArray.append(userModel)
                            friendListdispatchGroup.leave()
                        })
                    }
                }
                friendListdispatchGroup.notify(queue: .main) {
                    completionHandler(friendArray)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getUsers(completionHandler : @escaping ([UserModel]?)->Void) {
        let userQ = Auth.auth().currentUser
        
        let fetchUserGroup = DispatchGroup()
        let fetchUserComponentsGroup = DispatchGroup()
        fetchUserGroup.enter()
        
        ref.child("User").observeSingleEvent(of: .value) { (snapshot, error) in
            if error == nil {
                var userArray = [UserModel]()
                guard let snap = snapshot.value as? [String:Any]
                    else {
                        completionHandler(nil)
                        return
                }
                for record in snap {
                    let uid : String = record.key
                    if userQ?.uid != uid {
                        let user = snap[uid] as! [String:Any]
                        var userModel = UserModel(uid, info: user)
                        
                        fetchUserComponentsGroup.enter()
                        self.getUserImg(id: uid, completionHandler: { (data, error) in
                            if error == nil && !(data == nil){
                                userModel.image = UIImage(data: data!)
                            }
                            userArray.append(userModel)
                            fetchUserComponentsGroup.leave()
                        })
                    }
                }
                fetchUserComponentsGroup.notify(queue: .main) {
                    fetchUserGroup.leave()
                }
                
                fetchUserGroup.notify(queue: .main) {
                    completionHandler(userArray)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getUserImg(id : String, completionHandler : @escaping (Data?,Error?)->Void){
            let imagename = "UserImage/\(id).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imagename)
            storageRef.getData(maxSize: 1*300*300) { (data, error) in
                completionHandler(data,nil)
            }
    }
    
    func signInUserAccount(email : String, password : String, completionHandler : @escaping (Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
            }else{
                completionHandler(error)
            }
        }
    }
    
    func signUpUserAccount(userModel : UserModel, completionHandler : @escaping (Error?)->Void){
        Auth.auth().createUser(withEmail: userModel.email, password: userModel.password!) { (result, error) in
            if error == nil{
                if let user = result?.user{
                    let dict = UserModel(userModel.uid, info: user as! [String:Any])
                    
//                    let dict = ["FirstName":userModel.firstName, "LastName" : userModel.lastName,"Email": userModel.email, "Gender" : userModel.gender,"Latitude" : userModel.latitude, "Longitude" : userModel.longitude]
                    self.ref.child("User").child(user.uid).setValue(dict)
                }
            }else{
                completionHandler(error)
            }
        }
    }
    
    func resetPasswordUserAccount(email : String, completionHandler : @escaping (Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completionHandler(error)
        }
    }

}
