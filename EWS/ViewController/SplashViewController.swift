//
//  SplashViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/14/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import TAPageControl
import VGContent
import iCarousel

class FTLoginContent: VGCarouselContent {
    
    //MARK: - Setup
    
    override func setup() {
        super.setup()
        self.cellIdentifier = SplashView.identifier()
        self.carousel?.isPagingEnabled = true
    }
}

class SplashViewController: BaseViewController,VGCarouselContentDelegate {

    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: TAPageControl!
    var content : FTLoginContent!
    let arrImage = ["Splash1", "Splash2", "Splash3", "Splash4", "Splash5", ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.content = FTLoginContent(view: self.carouselView)
        self.content.delegate = self
        self.content.setItems(arrImage)
        self.pageControl.numberOfPages = 6
        self.pageControl.currentPage = 0
        self.pageControl.dotImage = UIImage(named: "pageControlUnselected")
        self.pageControl.currentDotImage = UIImage(named: "pageControlSelected")
    }
    
    //MARK: - VGCarouselContentDelegate
    func content(_ content: VGURLContent!, didChangeCurrentItem item: Any!) {
        self.pageControl.currentPage = carouselView.currentItemIndex
        self.playSelectedVideo()
    }

    func playSelectedVideo() {
        if let object = self.content.selectedItem as? String {
            if object == "Splash5"{
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let nav =  mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                navigationController?.pushViewController(nav, animated: true)
                                //UIApplication.shared.keyWindow?.rootViewController = nav
            }
        }
    }
    


}
