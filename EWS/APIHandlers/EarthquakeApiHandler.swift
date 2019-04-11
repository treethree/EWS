//
//  EarthquakeApiHandler.swift
//  EWS
//
//  Created by SHILEI CUI on 4/11/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
let baseAPIUrlForEQ = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_day.geojson"

class EarthquakeApiHandler: NSObject {
    static let sharedInstance = EarthquakeApiHandler()
    private override init() {}
    
//    func getApiForWeather(lat : Double, lot : Double ,completion: @escaping (_ arrayWeather: Weather?, _ error: Error?) -> Void){
//
//        let urlString = String(format: baseAPIUrl, arguments:[lat,lot])
//        guard let url = URL(string: urlString) else{
//            return
//        }
//        URLSession.shared.dataTask(with : url){ (data, response, error) in
//            if error == nil{
//                do{
//                    let weath = try? JSONDecoder().decode(Weather.self, from: data!)
//                    DispatchQueue.main.async {
//                        completion(weath,nil)
//                    }
//                }
//            }
//            }.resume()
//    }
}
