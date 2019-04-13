//
//  FeedViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var pArray = [[String:Any]]()
    @IBOutlet weak var colView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        getPostData()
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getPostData(){
        FirebaseApiHandler.sharedInstance.getPosts { (postArr) in
            if postArr != nil{
                self.pArray = postArr!
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
        print(pArray[indexPath.row].description)
        cell?.descLbl.text = pArray[indexPath.row].description

        return cell!
    }
}
