//
//  LoginViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/8/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLoginForm()
    }
    
    func createLoginForm(){
        form +++ Section()
            
            <<< AccountRow("accountRow") {
                $0.placeholder = "User Name"
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
            <<< ButtonRow() {
                $0.title = "Submit"
                }.onCellSelection({ (cell, row) in
                    print(self.form.values())
                    self.signUserAccount()
                })
            <<< ButtonRow() {
                $0.title = "Create new account"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")
                    self.present(vc!, animated: true, completion: nil)
                })
            <<< ButtonRow() {
                $0.title = "Forget Password"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")
                    self.present(vc!, animated: true, completion: nil)
                })
    }
    
    func signUserAccount(){
        let formVal = form.values()
        Auth.auth().signIn(withEmail: formVal["accountRow"] as! String, password: formVal["passwordRow"] as! String) { (result, error) in
            if error == nil{
                if let user = result?.user{
                    
                    print(user.email)
                    print(user.uid)
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }

}
