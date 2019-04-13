//
//  AddPostViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/12/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postBtnClick(_ sender: UIButton) {
        if imgView.image != nil {
            FirebaseApiHandler.sharedInstance.addPost(img: imgView.image!, postdesc: txtView.text) { (error) in
                print(error)
            }
        }
    }
    
    @IBAction func uploadPicBtnClick(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated:true, completion:nil)
    }
}

extension AddPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("Missing image in %@")
            return }
        //saveUserImage(sImage: selectedImage)
        imgView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
