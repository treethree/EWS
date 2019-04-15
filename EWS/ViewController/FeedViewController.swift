//
//  FeedViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedViewController: UIViewController {

    var pArray : [[String:Any]] = []
    var postImgId = String()
    @IBOutlet weak var colView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        getPostData()
        DispatchQueue.main.async {
            self.colView.reloadData()
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.colView.reloadData()
        }
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getPostData(){
        SVProgressHUD.show()
        FirebaseApiHandler.sharedInstance.getPosts { (postArr) in
            if postArr != nil{
                self.pArray = postArr!
                DispatchQueue.main.async {
                    self.colView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
}

extension FeedViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCollectionViewCell
        cell?.layer.cornerRadius = 10.0
        SVProgressHUD.show()
        FirebaseApiHandler.sharedInstance.getPosts { (postArr) in
            if postArr != nil{
                self.pArray = postArr!
                    cell?.descLbl.text = self.pArray[indexPath.row]["comment"] as! String
                    self.postImgId = self.pArray[indexPath.row]["postID"]  as! String
                SVProgressHUD.show()
                FirebaseApiHandler.sharedInstance.getPostImg(id: self.postImgId, completionHandler: { (data, error) in
                    if data != nil{
                            cell?.weatherImgView.image = UIImage(data: data!)!
                            SVProgressHUD.dismiss()
                    }else{
                        print(error)
                        SVProgressHUD.dismiss()
                    }
                })
                SVProgressHUD.show()
                FirebaseApiHandler.sharedInstance.getUserImg(id: self.pArray[indexPath.row]["userID"] as! String, completionHandler: { (data, error) in
                    if data != nil{
                            cell?.profileImageView.image = UIImage(data: data!)
                            cell?.profileImageView.roundedImage()
                            SVProgressHUD.dismiss()
                    }else{
                        print(error)
                            SVProgressHUD.dismiss()
                    }
                })
                SVProgressHUD.show()
                FirebaseApiHandler.sharedInstance.getUserByID(userID: self.pArray[indexPath.row]["userID"] as! String, completionHandler: { (user) in
                    if user != nil{
                            cell?.fnameLbl.text = user?.fname
                            cell?.lnameLbl.text = user?.lname
                            SVProgressHUD.dismiss()
                    }else{
                        print("error")
                            SVProgressHUD.dismiss()
                    }
                    
                })
                SVProgressHUD.dismiss()
            }
        }



        return cell!
    }
}
