//
//  HomeViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class HomeViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var colView: UICollectionView!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userEmailLbl: UILabel!
    var curUser : UserModel?
    var curWeather : Weather?
    {
        didSet{
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.colView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.backgroundColor = .clear
        tblView.backgroundColor = .clear
        tblView.showsVerticalScrollIndicator = false
        tblView.bounces = false
        navigationController?.navigationBar.barStyle = .black
//        self.getCurrentUser()
//        DispatchQueue.main.async {
//            self.tblView.reloadData()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callWeatherAPI(lat: lat, lot: lot)
        self.getCurrentUser()
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    func getCurrentUser(){
        FirebaseApiHandler.sharedInstance.getCurrentUserInfo { (userModel) in
            self.curUser = userModel
            //DispatchQueue.main.async {
                self.userEmailLbl.text = self.curUser?.email
            //}
            SVProgressHUD.show()
            FirebaseApiHandler.sharedInstance.getUserImg(id: self.curUser!.uid, completionHandler: { (data, error) in
                if data != nil{
                    DispatchQueue.main.async {
                        self.profileImgView.image = UIImage(data : data!)
                        self.profileImgView.roundedImage()
                        SVProgressHUD.dismiss()
                    }
                }else{
                    print(error)
                   // DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                   // }
                }
            })
        }
    }

    func callWeatherAPI(lat: Double, lot: Double)  {
        SVProgressHUD.show()
        WeatherApiHandler.sharedInstance.getApiForWeather(lat: lat, lot: lot) { (Weather, error) in
            if Weather != nil{
                self.curWeather = Weather!
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }else{
                print("error found!")
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    @IBAction func locationBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func earthquakeBtnClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EarthquakeViewController")
        //navigationController?.pushViewController(vc!, animated: true)
        present(vc!, animated: true, completion: nil)
    }
    
}



extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherTableViewCell
        let signTemp = String(format:"%@", "\u{00B0}") as String
        
        
        if let tempObj = curWeather?.daily.data[indexPath.row]{
            var myMilliseconds: UnixTime = tempObj.time
            
            cell?.tempLbl.text = "H: \(String(tempObj.temperatureMax))\(signTemp)F / L: \(String(tempObj.temperatureMin))\(signTemp)F"
            cell?.timezoneLbl.text = curWeather?.timezone
            cell?.summaryLbl.text = curWeather?.daily.summary
            cell?.dateLbl.text = myMilliseconds.toDay
            cell?.timeLbl.text = myMilliseconds.toHour
            cell?.iconImgView.image = UIImage(named: tempObj.icon)
            cell?.iconImgView.roundedImage()
            cell?.layer.cornerRadius = 10.0
            
        }
        return cell!
            
    }
}


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curWeather?.daily.data.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as? WeatherCollectionViewCell
        let signTemp = String(format:"%@", "\u{00B0}") as String
        if let tempObj = curWeather?.daily.data[indexPath.row]{
            var myMilliseconds: UnixTime = tempObj.time
            cell?.hiTempLbl.text = "H: \(String(tempObj.temperatureMax))\(signTemp)F"
            cell?.lowTempLbl.text = "L: \(String(tempObj.temperatureMin))\(signTemp)F"
            cell?.timezoneLbl.text = curWeather?.timezone
            cell?.dateLbl.text = myMilliseconds.toDay
            cell?.imgView.image = UIImage(named: tempObj.icon)
            cell?.layer.cornerRadius = 10.0
        }
        return cell!
    }
    
    
}
