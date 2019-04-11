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
    
    func signInUserAccount(email : String, password : String, completionHandler : @escaping (Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
            }else{
                completionHandler(error)
            }
        }
    }
    
    func signUpUserAccount(userModel : UserModel, completionHandler : @escaping (Error?)->Void){
        Auth.auth().createUser(withEmail: userModel.email!, password: userModel.password!) { (result, error) in
            if error == nil{
                if let user = result?.user{
                    let dict = ["FirstName":userModel.firstName, "LastName" : userModel.lastName,"Email": userModel.email, "Gender" : userModel.gender,"Latitude" : userModel.latitude, "Longitude" : userModel.longitude]
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
