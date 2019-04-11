//
//  SettingViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        // Do any additional setup after loading the view.
    }
    func signOutUserAccount(){
        //better use do try catch
        try! Auth.auth().signOut()
    }
    
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        signOutUserAccount()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        present(vc!, animated: true, completion: nil)
    }
    
}
