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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGms.mapType = .normal
        // Do any additional setup after loading the view.
        let location = CLLocation(latitude: 43.4343, longitude: -120.3434)
        setupCordinate(loc: location)
    }
    
    func setupCordinate(loc : CLLocation){
        //let location = CLLocation(latitude: 43.4343, longitude: -120.3434)
        let marker = GMSMarker()
        marker.title = "One Location"
        marker.position = loc.coordinate
        marker.map = viewGms
        marker.isDraggable = true
        setUpAnimationImage(markerImg: marker)

//        let location2 = CLLocation(latitude: 44.4343, longitude: -121.3434)
//        let marker2 = GMSMarker()
//        marker2.title = "Second Location"
//        marker2.position = location2.coordinate
//        marker2.map = viewGms
//        marker2.isDraggable = true

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
