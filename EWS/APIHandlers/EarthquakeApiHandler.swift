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
    
    func getApiForEQ(completion: @escaping (_ arrayWeather: Earthquake?, _ error: Error?) -> Void){

        guard let url = URL(string: baseAPIUrlForEQ) else{
            return
        }
        URLSession.shared.dataTask(with : url){ (data, response, error) in
            if error == nil{
                do{
                    let eq = try? JSONDecoder().decode(Earthquake.self, from: data!)
                    DispatchQueue.main.async {
                        completion(eq,nil)
                    }
                }
            }
            }.resume()
    }
}
