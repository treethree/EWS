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
    
    func getPosts(completionHandler: @escaping ([[String:Any]]?)->Void) {
        
        var postArr = [[String:Any]]()
        //let postListdispatchGroup = DispatchGroup()
        //let fetchUserComponentsGroup = DispatchGroup()
        self.ref.child("Post").observeSingleEvent(of: .value) {
            (snapshot) in
            if let posts = snapshot.value as? [String:Any] {
                for record in posts {
                    //postListdispatchGroup.enter()
                    let key = record.key
                    let post = posts[key] as! [String:Any]
                    var postDict = [String:Any]()
                    //fetchUserComponentsGroup.enter()
//                    self.getUserByID(userID: post["userID"] as! String, completionHandler: { (user) in
//                        postDict["user"] = user
//                        //fetchUserComponentsGroup.leave()
//                    })
                    postDict["userID"] = post["userID"]
                    postDict["postID"] = key
                    postDict["comment"] = post["describtion"]
                    postDict["timestamp"] = post["timestamp"]
                    postArr.append(postDict)
                    //self.getPostImg(id: key, completionHandler: { (data, error) in
                        //if error == nil && data != nil {
                           // postDict["postImg"] = UIImage(data: data!)
//                        } else {
//                            postDict["postImg"] = nil
//                        }
//                        fetchUserComponentsGroup.notify(queue: .main) {
//                            postArr.append(postDict)
//                            postListdispatchGroup.leave()
//                        }
                    //})
                }
                completionHandler(postArr)
                
//                postListdispatchGroup.notify(queue: .main) {
//                    completionHandler(postArr)
//                }
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
//            self.getUserImg(id: use.uid, completionHandler: { (data, error) in
//                if data != nil{
//                    use.image = UIImage(data: data!)
//                }else{
//                    print(error)
//                }
//            })
            completionHandler(use)
//            self.getUserImg(id: userID, completionHandler: { (data, error) in
//                if data != nil{
//                    let use = UserModel(userID, info: snap)
//                }
//            })
            
//            self.getUserImg(id: userID, completionHandler: { (data, error) in
//                let use = UserModel(userID: userID, fname: snap["FirstName"] as! String, lname: snap["Lastname"] as! String, email: snap["Email"] as! String, address: snap["Address"] as! String , phone: snap["Phone"] as! String, password: nil, image: UIImage(data: data ?? Data()), latitude: (37.2131 as! Double), longitude: (-121.3232 as! Double))
//                completionHandler(use)
//            })
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
