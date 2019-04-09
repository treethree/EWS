//
//  ViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/8/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    @IBAction func btnClick(_ sender: UIButton) {
        createUserAccount()
    }
    
    func createUserAccount(){
        Auth.auth().createUser(withEmail: "Rose@gmail.com", password: "1234567") { (result, error) in
            if error == nil{
                if let user = result?.user{

                    let dict = ["Fname":"Rose", "Lname" : "Zhou", "Email": user.email]
                    self.ref.child("User").child(user.uid).setValue(dict)
                    print(user.email)
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func signUserAccount(){
        Auth.auth().signIn(withEmail: "Shilei@gmail.com", password: "1234567") { (result, error) in
            if error == nil{
                if let user = result?.user{
                    print(user.email)
                    //uid is unique
                    print(user.uid)
                }
            }else{
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func signOutUserAccount(){
        //better use do try catch
        try! Auth.auth().signOut()
    }
    
    func resetPasswordUserAccount(){
        Auth.auth().sendPasswordReset(withEmail: "Shilei@gmail.com") { (error) in
            print(error?.localizedDescription)
        }
    }
    
}

