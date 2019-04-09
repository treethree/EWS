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
        
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        
        createLoginForm()
    }
    
    func createLoginForm(){
        form +++ Section()
            //email account
            <<< AccountRow("accountRow") {
                $0.placeholder = "User Name"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.backgroundColor = UIColor.red
                    }
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "user")
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< PasswordRow("passwordRow") {
                $0.placeholder = "Password"
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 13))
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "password")
            }
            <<< ButtonRow() {
                $0.title = "Submit"
                }.onCellSelection({ (cell, row) in
                    print(self.form.values())
                    self.signUserAccount()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vc!, animated: true, completion: nil)
                })
            <<< ButtonRow() {
                $0.title = "Create new account"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)
                    //self.present(vc!, animated: true, completion: nil)
                })
            <<< ButtonRow() {
                $0.title = "Forget Password"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)
                    //self.present(vc!, animated: true, completion: nil)
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
