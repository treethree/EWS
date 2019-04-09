//
//  ResetPasswordViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth

class ResetPasswordViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        cresteRegistrationForm()
    }
    

    func cresteRegistrationForm(){
        form +++ Section()
            <<< EmailRow("emailRow") {
                $0.placeholder = "Email"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "email")
                }
            <<< ButtonRow() {
                $0.title = "Reset"
                }.onCellSelection({ (cell, row) in
//                    print(self.form.values())
                    self.resetPasswordUserAccount()
                    //self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                })
    }
    
    func resetPasswordUserAccount(){
        Auth.auth().sendPasswordReset(withEmail: form.values()["emailRow"] as! String) { (error) in
            print(error?.localizedDescription)
        }
    }

}
