//
//  FriendsMapViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/12/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class FriendsMapViewController: UIViewController {

    @IBOutlet weak var viewGms: GMSMapView!
    var userArray = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        viewGms.mapType = .normal
        getUserLocation()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func getUserLocation(){
        FirebaseApiHandler.sharedInstance.getFriends { (userArr) in
            if userArr != nil{
                self.userArray = userArr!
                for user in userArr!{
                    let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
                    self.setupCordinate(loc: location)
                }
            }else{
                print("error")
            }
        }
    }
    
    func setupCordinate(loc : CLLocation){
        let marker = GMSMarker()
        marker.title = "One Location"
        marker.position = loc.coordinate
        marker.map = viewGms
        marker.isDraggable = true
        for user in userArray{
            SVProgressHUD.show()
            FirebaseApiHandler.sharedInstance.getUserImg(id: user.uid) { (data, error) in
                if data != nil{
                    let profilePic = UIImage(data: data!, scale: 15)
                    let markerView = UIImageView(image: profilePic)
                    markerView.roundedImage()
                    marker.iconView = markerView
                    SVProgressHUD.dismiss()
                }else{
                    print(error)
                    SVProgressHUD.dismiss()
                }
                
            }
        }
        
        //marker.icon =
        
        viewGms.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 5)
    }


}
