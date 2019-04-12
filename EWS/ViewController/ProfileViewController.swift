//
//  ProfileViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController:  FormViewController{
    var ref: DatabaseReference!
    var currentUser = [String: Any]()
    @IBOutlet weak var profileImgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false

        getCurrentUserInfo()
        getUserImage()
    }
    
    func getCurrentUserInfo(){
            if let user = Auth.auth().currentUser{
                self.ref.child("User").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
                    if let userObj = snapshot.value as? [String:Any]{
                        print(userObj)
                        self.currentUser = userObj
                        self.createProfileForm()
//                        if self.profileImgView.image != nil{
//                            self.getUserImage()
//                        }
                    }
                }
            }
    }
    //Update firebase database
    @IBAction func saveBtnClick(_ sender: UIButton) {
        let formvalues = self.form.values()
            if let user = Auth.auth().currentUser{
                self.ref.child("User").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
                    let dict = ["fname": formvalues["firstNameRow"],"lname": formvalues["lastNameRow"], "email": formvalues["emailRow"]]
                    self.ref.child("User").child(user.uid).updateChildValues(dict)
                }
            }
        dismiss(animated: true, completion: nil)
    }
    
    func createProfileForm(){
        form +++ Section()
            <<< NameRow("firstNameRow") {
                $0.placeholder = "First Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "user")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.value = self.currentUser["fname"] as? String
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
            <<< NameRow("lastNameRow") {
                $0.placeholder = "Last Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "user")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.value = self.currentUser["lname"] as? String
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
            <<< EmailRow("emailRow") {
                $0.placeholder = "Email"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "email")
                    cell.backgroundColor = .clear
                    cell.layer.cornerRadius = 8.0
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.masksToBounds = true
                    row.value = self.currentUser["email"] as? String
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
    }

}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBAction func editImageBtnClick(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated:true, completion:nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("Missing image in %@")
            return }
        saveUserImage(sImage: selectedImage)
        profileImgView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //save image into firebase storage
    func saveUserImage(sImage : UIImage){
        if let user = Auth.auth().currentUser{
            //let image = UIImage(named: "Pic")
            let imgData = sImage.jpegData(compressionQuality: 0)
            let metaData = StorageMetadata()
            metaData.contentType = "Image/jepg"
            //unique image name with UID
            let imagename = "UserImage/\(String(user.uid)).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imagename)
            storageRef.putData(imgData!, metadata: metaData)
        }
    }
    //get image from firebase storage
    func getUserImage(){
        if let user = Auth.auth().currentUser{
            let imagename = "UserImage/\(String(user.uid)).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imagename)
            storageRef.getData(maxSize: 1*300*300) { (data, error) in
                let img = UIImage(data: data!)
                self.profileImgView.image = img
            }
        }
    }
}
