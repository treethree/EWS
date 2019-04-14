//
//  FeedViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var pArray : [[String:Any]] = []
    var postImgId = String()
    @IBOutlet weak var colView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        getPostData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        colView.reloadData()
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getPostData(){
        FirebaseApiHandler.sharedInstance.getPosts { (postArr) in
            if postArr != nil{
                self.pArray = postArr!
                DispatchQueue.main.async {
                    self.colView.reloadData()
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
        FirebaseApiHandler.sharedInstance.getPosts { (postArr) in
            if postArr != nil{
                self.pArray = postArr!
                //print("post array is : \(self.pArray)")
                //postID : (value : "-LcNBDdPtkaTel1NNVS5")
                cell?.descLbl.text = self.pArray[indexPath.row]["comment"] as! String
                self.postImgId = self.pArray[indexPath.row]["postID"]  as! String
                
                FirebaseApiHandler.sharedInstance.getPostImg(id: self.postImgId, completionHandler: { (data, error) in
                    if data != nil{
                        cell?.weatherImgView.image = UIImage(data: data!)!
                    }else{
                        print(error)
                    }
                })
                
                FirebaseApiHandler.sharedInstance.getUserImg(id: self.pArray[indexPath.row]["userID"] as! String, completionHandler: { (data, error) in
                    if data != nil{
                        cell?.profileImageView.image = UIImage(data: data!)
                        cell?.profileImageView.roundedImage()
                    }else{
                        print(error)
                    }
                })
                
                FirebaseApiHandler.sharedInstance.getUserByID(userID: self.pArray[indexPath.row]["userID"] as! String, completionHandler: { (user) in
                    if user != nil{
                        cell?.fnameLbl.text = user?.fname
                        cell?.lnameLbl.text = user?.lname
                    }
                    print(user)
                })
            }
        }



        return cell!
    }
}
