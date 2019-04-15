//
//  LoginViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/8/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Eureka
import SVProgressHUD

class LoginViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LogIn"
        
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        
        createLoginForm()
    }
    
    func createLoginForm(){
        form +++ Section()
            //email account
            <<< AccountRow("accountRow") {
                $0.placeholder = "User Name(Email)"
                $0.placeholderColor = UIColor.white
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.backgroundColor = UIColor.red
                    }
                    cell.textField.textColor = UIColor.white
                }
                .cellSetup { cell, row in
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true

                    cell.imageView?.image = UIImage(named: "email")
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
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                    cell.textField.textColor = UIColor.white
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
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    cell.imageView?.image = UIImage(named: "password")
            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< ButtonRow() {
                $0.title = "Submit"
                }.onCellSelection({ (cell, row) in
                    let formVal = self.form.values()
                    SVProgressHUD.show()
                    FirebaseApiHandler.sharedInstance.signInUserAccount(email: formVal["accountRow"] as! String, password: formVal["passwordRow"] as! String, completionHandler: { (error) in
                        print("Login error!")
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    })
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
                    self.present(vc!, animated: true, completion: nil)
                })
                .cellSetup { cell, row in
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.cell.tintColor = UIColor.white
            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            
            <<< ButtonRow() {
                $0.title = "Create new account"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)
                })
                .cellSetup { cell, row in
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.cell.tintColor = UIColor.white
            }
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< ButtonRow() {
                $0.title = "Forget Password"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)

                })
                .cellSetup { cell, row in
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.cell.tintColor = UIColor.white
        }
    }

}
