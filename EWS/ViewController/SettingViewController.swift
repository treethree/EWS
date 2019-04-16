//
//  SettingViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    func signOutUserAccount(){
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        signOutUserAccount()
        GIDSignIn.sharedInstance()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        present(vc!, animated: true, completion: nil)
    }
    
}
