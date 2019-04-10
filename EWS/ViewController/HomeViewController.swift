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

class HomeViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var curWeather : Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage("bgimage", contentMode: .scaleAspectFit)
          callWeatherAPI(lat: 37.8267, lot: -122.4233)
    }
    
    func callWeatherAPI(lat: Double, lot: Double)  {
        Apihandler.sharedInstance.getApiForWeather(lat: lat, lot: lot) { (Weather, error) in
            if Weather != nil{
                //DispatchQueue.main.async {
                self.curWeather = Weather!
                self.tblView.reloadData()
                    //print(self.curWeather)
                //}
            }
            print("error found!")
        }
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
        }
        return cell!
            
    }
    
    
}
