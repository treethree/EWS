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
    
    func signinAndCheckIfCurrentUserExist(userId : String, completionHandler: @escaping (Bool)->Void){
        self.getUsers { (userArr) in
            for user in userArr!{
                if user.uid == userId{
                    completionHandler(true)
                    return
                }
            }
            completionHandler(false)
        }
    }
    func chatKey(uid : String, friendID: String)->String{
        return uid < friendID ? "\(uid)\(friendID)" : "\(friendID)\(uid)"
    }
    
    func sendText(friendID : String, msg: String, completionHandler: @escaping (Error?)->Void){
        let time = Date().timeIntervalSince1970
        let uid = (Auth.auth().currentUser?.uid)!
        let key = chatKey(uid: uid, friendID: friendID)
        let msgKey = "\(Int(time))"
        let info = [
            "receiverID": friendID,
            "message": msg,
            "time": String(time)
        ]
        
        ref.child("Conversations").child(key).child(msgKey).setValue(info) { error, ref in
            if let error = error {
                print(error.localizedDescription)
            } else { print(error) }
        }
    }
    
    func getConversation(friendID: String, completion: @escaping ([ChatInfo]?) -> Void) {
        let uid = (Auth.auth().currentUser?.uid)!
        let key = chatKey(uid: uid, friendID: friendID)
        ref.child("Conversations").child(key).observeSingleEvent(of: .value) { (snapshot) in
            if let msgList = snapshot.value as? [String : Any] {
                let chatList = msgList.map({ ChatInfo(info: $1 as! [String : Any]) })
                completion(chatList)
            } else { completion(nil) }
        }
    }
    
    
    func getPosts(completionHandler: @escaping ([[String:Any]]?)->Void) {
        
        var postArr = [[String:Any]]()
        self.ref.child("Post").observeSingleEvent(of: .value) {
            (snapshot) in
            if let posts = snapshot.value as? [String:Any] {
                for record in posts {
                    let key = record.key
                    let post = posts[key] as! [String:Any]
                    var postDict = [String:Any]()
                    postDict["userID"] = post["userID"]
                    postDict["postID"] = key
                    postDict["comment"] = post["describtion"]
                    postDict["timestamp"] = post["timestamp"]
                    postArr.append(postDict)
                }
                completionHandler(postArr)
                
            }else {
                completionHandler(nil)
            }
        }
    }
    
    func getUserByID(userID: String, completionHandler : @escaping (UserModel?)->Void) {
        
        ref.child("User").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snap = snapshot.value as? [String:Any]
                else {
                    completionHandler(nil)
                    return
            }
            var use = UserModel(userID, info: snap)
            completionHandler(use)

        })
    }
    
    func getPostImg(id : String,completionHandler : @escaping (Data?,Error?)->Void) {
        let imageName = "Post/\(String(describing: id)).jpeg"
        var storageRef : StorageReference?
        storageRef = Storage.storage().reference()
        storageRef = storageRef?.child(imageName)
        storageRef?.getData(maxSize: 1*300*300, completion: { (data, error) in
            completionHandler(data,error)
        })
    }
    
    func addPost(img : UIImage , postdesc : String? , completionHandler: @escaping (Error?)->Void) {
        let user = Auth.auth().currentUser
        let postKey = self.ref.child("Post").childByAutoId().key
        let postDict = ["userID" : user?.uid, "describtion" : postdesc ?? "" , "timestamp" : "\(NSDate().timeIntervalSince1970)"]
        
        self.ref.child("Post").child(postKey!).setValue(postDict) { (error, ref) in
            if error != nil {
                completionHandler(error)
            } else {
                self.savePostImg(id: postKey!, img: img, completionHandler: { (error) in
                    if error != nil {
                        completionHandler(error)
                    } else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    func savePostImg(id : String,img :UIImage,completionHandler : @escaping (Error?)->Void) {
        let image = img
        let imgData = image.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imgName = "Post/\(String(describing: id)).jpeg"
        var storageRef = Storage.storage().reference()
        storageRef = storageRef.child(imgName)
        storageRef.putData(imgData!, metadata: metaData) { (data, error) in
            completionHandler(error)
        }
    }
    
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
                        
                        var userModel = UserModel(friend.key,info: singleFriend)

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
    
    func getCurrentUserInfo(completionHandler : @escaping (UserModel?)->Void){
        if let user = Auth.auth().currentUser{
            self.ref.child("User").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
                if let userObj = snapshot.value as? [String:Any]{
                    var userModel = UserModel(user.uid, info: userObj)
                    completionHandler(userModel)
                }
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
                    //let dict = UserModel(userModel.uid, info: user as! [String:Any])
                    
                    let dict = ["fname":userModel.fname, "lname" : userModel.lname,"email": userModel.email, "dob" : "", "phone" : "","gender" : userModel.gender,"location" : "", "latitude" : userModel.latitude, "longitude" : userModel.longitude, "password" : "", "uid" : user.uid ] as [String : Any]
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
