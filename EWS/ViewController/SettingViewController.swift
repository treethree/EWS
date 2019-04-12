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
        do {
            try Auth.auth().signOut()
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let signupScreen = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//            UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.6, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
//                UIApplication.shared.keyWindow?.rootViewController = signupScreen
//            }, completion: nil)
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        signOutUserAccount()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.pushViewController(vc!, animated: true)
        print("lol")
    }
    
}
