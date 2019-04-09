//
//  RegistrationViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/8/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: FormViewController {
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false

        cresteRegistrationForm()
    }
    
    func cresteRegistrationForm(){
        form +++ Section()
            
            <<< NameRow("firstNameRow") {
                $0.placeholder = "First Name"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            <<< NameRow("lastNameRow") {
                $0.placeholder = "Last Name"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            <<< AccountRow("userNameRow") {
                $0.placeholder = "User Name"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            <<< EmailRow("emailRow") {
                $0.placeholder = "Email"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            <<< PasswordRow("passwordRow") {
                $0.placeholder = "Password"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
    }

    @IBAction func SignUpBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let errors = form.validate()
        print(errors)
        print(form.values())
        createUserAccount()
        dismiss(animated: true, completion: nil)
        //print(form.values()["emailRow"])
    }
    
    func createUserAccount(){
        let formVal = form.values()
        Auth.auth().createUser(withEmail: formVal["emailRow"] as! String, password: formVal["passwordRow"] as! String) { (result, error) in
            if error == nil{
                if let user = result?.user{
                    let dict = ["FirstName":formVal["firstNameRow"], "LastName" : formVal["lastNameRow"], "UserName": formVal["userNameRow"],"Email": user.email]
                    self.ref.child("User").child(user.uid).setValue(dict)
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
}
