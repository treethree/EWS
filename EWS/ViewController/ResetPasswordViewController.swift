//
//  ResetPasswordViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Eureka

class ResetPasswordViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reset Password"
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false

        createResetPasswordForm()
    }
    

    func createResetPasswordForm(){
        form +++ Section()
            <<< EmailRow("emailRow") {
                $0.placeholder = "Email"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "email")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.backgroundColor = UIColor.red
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
            <<< SpaceCellRow(){
                $0.cell.spaceHeight = 10
                $0.cell.backgroundColor = .clear
            }
            <<< ButtonRow() {
                $0.title = "Reset"
                }.onCellSelection({ (cell, row) in
                    FirebaseApiHandler.sharedInstance.resetPasswordUserAccount(email: self.form.values()["emailRow"] as! String, completionHandler: { (error) in
                        print("Error in reset password")
                    })
                    self.navigationController?.popViewController(animated: true)
                })
                .cellSetup { cell, row in
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
        }
    }

}
