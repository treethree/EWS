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
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import TWMessageBarManager
import SVProgressHUD

class LoginViewController: FormViewController, GIDSignInDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate {

    //customize the google signin button
    @IBOutlet weak var googleSigninoutlet: GIDSignInButton!
    @IBOutlet weak var facebookSigninOutlet: FBSDKLoginButton!
    
    var userRef : DatabaseReference!
    var userstorageRef : StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        facebookSigninOutlet.delegate = self
        facebookSigninOutlet.readPermissions = ["public_profile", "email"]
        
        self.userRef = Database.database().reference().child("User")
        self.userstorageRef = Storage.storage().reference()
        
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        navigationController?.navigationBar.backgroundColor = .clear
        createLoginForm()
        //facebookSigninOutlet.titleLabel?.text = "Facebook Sign in"

    }
    
    @IBAction func facebookBtnClick(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
//        self.present(vc!, animated: true, completion: nil)
    }
    
    //MARK: -FacebookSignInDelegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let err = error {
            TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            print(err)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
                print(err)
                return
            }
            SVProgressHUD.show()
            FirebaseApiHandler.sharedInstance.signinAndCheckIfCurrentUserExist(userId: (Auth.auth().currentUser?.uid)!, completionHandler: {
                (result) in
                if result {
                    print("current user exist")
                } else {
                    print("current user not exist")
//                    print(authResult?.user.displayName)
//                    print(authResult?.user.providerID)
//                    print(authResult?.user.uid)
//                    print(authResult?.user.providerData[0].email)
//                    print(authResult?.user.email)
                    var fullName = authResult?.user.displayName?.components(separatedBy: " ")
                    let userDict = ["fname":fullName?[0],
                                    "lname" : fullName?[1],
                                    "email": authResult?.user.providerData[0].email,
                                    "dob" : "", "phone" : "",
                                    "gender" : "",
                                    "location" : "",
                                    "latitude" : lat,
                                    "longitude" : lot,
                                    "password" : "",
                                    "uid" : authResult?.user.uid ] as [String : Any]
                    
        self.userRef.child((authResult?.user.uid)!).updateChildValues(userDict, withCompletionBlock: {
                        (error, ref) in
                    })
                }
                Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
                self.present(controller!, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            })
            
            //
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    @IBAction func googleBtnClick(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //MARK: -GoogleSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            } else {
                SVProgressHUD.show()
                FirebaseApiHandler.sharedInstance.signinAndCheckIfCurrentUserExist(userId: (Auth.auth().currentUser?.uid)!, completionHandler: {
                    (result) in
                    if result {
                        print("current user exist")
                    } else {
                        print("current user not exist")
                        if let fireUser = user {
//                            print(fireUser.uid)
//                            print(fireUser.displayName)
//                            print(fireUser.email)
                            var fullName = fireUser.displayName?.components(separatedBy: " ")
                            let userDict = ["fname":fullName?[0],
                                            "lname" : fullName?[1],
                                            "email": fireUser.email,
                                            "dob" : "", "phone" : "",
                                            "gender" : "",
                                            "location" : "",
                                            "latitude" : lat,
                                            "longitude" : lot,
                                            "password" : "",
                                            "uid" : fireUser.uid ] as [String : Any]
                            
                            self.userRef.child(fireUser.uid).updateChildValues(userDict, withCompletionBlock: {
                                (error, ref) in
                            })
                            Messaging.messaging().subscribe(toTopic: fireUser.uid)
                            
                        }
                    }
                    Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                    SVProgressHUD.dismiss()
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
                    self.present(controller!, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    
    func createLoginForm(){
        form +++ Section()
            //email account
            <<< AccountRow("accountRow") {
                $0.placeholder = "Username(Email)"
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
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                    cell.textField.textColor = UIColor.white
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
//                }
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
            <<< ButtonRow("submitRow") {
                $0.title = "Submit"
                }.onCellSelection({ (cell, row) in
                    let formVal = self.form.values()
                    if (formVal["accountRow"]! != nil) && (formVal["passwordRow"]! != nil){
                        SVProgressHUD.show()
                        FirebaseApiHandler.sharedInstance.signInUserAccount(email: formVal["accountRow"] as! String, password: formVal["passwordRow"] as! String, completionHandler: { (error) in
                            print("Login error!")
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                            }
                            Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                        })
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
//                        self.present(vc!, animated: true, completion: nil)
                        let mainStoreBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = mainStoreBoard.instantiateViewController(withIdentifier: "MainTabBarViewController")
                        UIApplication.shared.keyWindow?.rootViewController = controller
                        
                    }else{
                        let alert = UIAlertController(title: "Sign In Error", message: "Make sure all info in form are correct!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
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
            
            <<< ButtonRow("newAccountRow") {
                $0.title = "Create new account"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")
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
            <<< ButtonRow("forgetPWRow") {
                $0.title = "Forget Password"
                }.onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")
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
    }

}
