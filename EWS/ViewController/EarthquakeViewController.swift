//
//  EarthquakeViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/10/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import GoogleMaps

class EarthquakeViewController: BaseViewController {

    @IBOutlet weak var viewGms: GMSMapView!
    var eq : Earthquake?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGms.mapType = .normal
        // Do any additional setup after loading the view.
        
        callEarthquakeAPI()
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.popViewController(animated: true)
//    }
    
    func callEarthquakeAPI()  {
        EarthquakeApiHandler.sharedInstance.getApiForEQ { (earthquake, error) in
            if earthquake != nil{
                self.eq = earthquake
                for item in self.eq!.features{
                    let lot = item.geometry.coordinates[0]
                    let lat = item.geometry.coordinates[1]
                    let location = CLLocation(latitude: lat, longitude: lot)
                    self.setupCordinate(loc : location)
                }
            }else{
                print("error found!")
            }
        }
    }
    
    
    func setupCordinate(loc : CLLocation){
        //let location = CLLocation(latitude: 43.4343, longitude: -120.3434)
        let marker = GMSMarker()
        marker.title = "One Location"
        marker.position = loc.coordinate
        marker.map = viewGms
        marker.isDraggable = true
        setUpAnimationImage(markerImg: marker)

        viewGms.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 5)
    }
    
    func setUpAnimationImage(markerImg : GMSMarker){
        var arrImg : Array<UIImage> = []
        for i in 1...44 {
            arrImg.append(UIImage(named: "Anim 2_\(i)")!)
        }
        markerImg.icon = UIImage.animatedImage(with: arrImg, duration: 3.0)
    }

} 
