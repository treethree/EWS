//
//  ApiHandler.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
let baseAPIUrl = "https://api.darksky.net/forecast/68a4eee2e315f76149908dc5f3a1d092/%f,%f"

class Apihandler: NSObject {
    static let sharedInstance = Apihandler()
    private override init() {}
    
    func getApiForWeather(lat : Double, lot : Double ,completion: @escaping (_ arrayWeather: Weather?, _ error: Error?) -> Void){
        
        let urlString = String(format: baseAPIUrl, arguments:[lat,lot])
        guard let url = URL(string: urlString) else{
            return
        }
        URLSession.shared.dataTask(with : url){ (data, response, error) in
            if error == nil{
                do{
                    //print(urlString)
                    let weath = try? JSONDecoder().decode(Weather.self, from: data!)
                    //print(weath)
                    DispatchQueue.main.async {
                        completion(weath,nil)
                    }
                    //                    catch{
                    //                        completion(nil,error)
                    //                    }
                }
            }
            }.resume()
    }
}

