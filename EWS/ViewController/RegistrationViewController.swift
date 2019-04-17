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
import SVProgressHUD

class RegistrationViewController: FormViewController {
    var userInfo : UserModel?
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        ref = Database.database().reference()
        
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        //navigationController?.navigationBar.backgroundColor = .clear
        createRegistrationForm()
    }
    
    func createRegistrationForm(){
        form +++ Section()
            
            <<< NameRow("firstNameRow") {
                $0.placeholder = "First Name"
                $0.placeholderColor = UIColor.white
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate({ (cell, row) in
                    cell.textField.textColor = UIColor.white
                })
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "user")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
            }
//                .onRowValidationChanged { cell, row in
//                    let rowIndex = row.indexPath!.row
//                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
//                        row.section?.remove(at: rowIndex + 1)
//                    }
//                    if !row.isValid {
//                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
//                            let labelRow = LabelRow() {
//                                $0.title = validationMsg
//                                $0.cell.height = { 30 }
//                            }
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
//                        }
//                    }
//            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< NameRow("lastNameRow") {
                $0.placeholder = "Last Name"
                $0.placeholderColor = UIColor.white
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate({ (cell, row) in
                    cell.textField.textColor = UIColor.white
                })
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "user")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
            }
//                .onRowValidationChanged { cell, row in
//                    let rowIndex = row.indexPath!.row
//                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
//                        row.section?.remove(at: rowIndex + 1)
//                    }
//                    if !row.isValid {
//                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
//                            let labelRow = LabelRow() {
//                                $0.title = validationMsg
//                                $0.cell.height = { 30 }
//                            }
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
//                        }
//                    }
//            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< EmailRow("emailRow") {
                $0.placeholder = "Email"
                $0.placeholderColor = UIColor.white
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate({ (cell, row) in
                    cell.textField.textColor = UIColor.white
                })
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "email")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
            }
//                .onRowValidationChanged { cell, row in
//                    let rowIndex = row.indexPath!.row
//                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
//                        row.section?.remove(at: rowIndex + 1)
//                    }
//                    if !row.isValid {
//                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
//                            let labelRow = LabelRow() {
//                                $0.title = validationMsg
//                                $0.cell.height = { 30 }
//                            }
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
//                        }
//                    }
//            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< PasswordRow("passwordRow") {
                $0.placeholder = "Password"
                $0.placeholderColor = UIColor.white
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 13))
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate({ (cell, row) in
                    cell.textField.textColor = UIColor.white
                })
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "password")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
            }
//                .onRowValidationChanged { cell, row in
//                    let rowIndex = row.indexPath!.row
//                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
//                        row.section?.remove(at: rowIndex + 1)
//                    }
//                    if !row.isValid {
//                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
//                            let labelRow = LabelRow() {
//                                $0.title = validationMsg
//                                $0.cell.height = { 30 }
//                            }
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
//                        }
//                    }
//            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< PasswordRow("confirmpwRow") {
                $0.placeholder = "Confirm Password"
                $0.placeholderColor = UIColor.white
                $0.add(rule: RuleEqualsToRow(form: form, tag: "passwordRow"))
                }
                .cellUpdate({ (cell, row) in
                    cell.textField.textColor = UIColor.white
                })
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "password")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
        }
//                .onRowValidationChanged { cell, row in
//                    let rowIndex = row.indexPath!.row
//                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
//                        row.section?.remove(at: rowIndex + 1)
//                    }
//                    if !row.isValid {
//                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
//                            let labelRow = LabelRow() {
//                                $0.title = validationMsg
//                                $0.cell.height = { 30 }
//                            }
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
//                        }
//                    }
//        }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< SegmentedRow<String>("genderRow") { $0.options = ["Male", "Female"] }
                .cellSetup { cell, row in
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.cell.tintColor = UIColor.white
            }
    }

    @IBAction func SignUpBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let formVal = form.values()
        if (formVal["emailRow"]! != nil && formVal["passwordRow"]! != nil ){
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: formVal["emailRow"] as! String, password: formVal["passwordRow"] as! String) { (result, error) in
                if error == nil{
                    if let user = result?.user{
                        
                        let dict = ["fname":formVal["firstNameRow"],
                                    "lname" : formVal["lastNameRow"],
                                    "email": formVal["emailRow"],
                                    "dob" : "", "phone" : "",
                                    "gender" : formVal["genderRow"],
                                    "location" : "",
                                    "latitude" : lat,
                                    "longitude" : lot,
                                    "password" : formVal["passwordRow"],
                                    "uid" : user.uid ]
                        self.ref.child("User").child(user.uid).setValue(dict)
                    }
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }else{
                    print(error)
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
                
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Sign Up Error", message: "Make sure all info in form are correct!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

