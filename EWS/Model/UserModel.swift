//
//  UserModel.swift
//  EWS
//
//  Created by SHILEI CUI on 4/10/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import UIKit

struct UserModel{
//    var userID : String?
//    var firstName : String?
//    var lastName : String?
//    var email : String?
//    var gender : String?
//    var password: String?
//    var latitude: Double?
//    var longitude: Double?
//    var image : UIImage?
//
//    init(userID: String? = nil, firstName: String? = nil, lastName: String? = nil, email : String? = nil, gender : String? = nil , password : String? = nil, latitude : Double? = nil , longitude : Double? = nil, image : UIImage? = nil) {
//
//        self.userID = userID
//        self.firstName = firstName
//        self.lastName = lastName
//        self.email = email
//        self.gender = gender
//        self.password = password
//        self.latitude = latitude
//        self.longitude = longitude
//        self.image = image
//    }
    
    var fname, lname, email, dob, phone, gender : String
    var latitude, longitude: Double
    var location: String
    var uid: String
    var image: UIImage?
    var password : String?
    var senderId : String?
    
    init(_ uid: String, info: [String: Any]) {
        fname = info["fname"] as! String
        lname = info["lname"] as! String
        email = info["email"] as! String
        dob = info["dob"] as! String
        phone = info["phone"] as! String
        gender = info["gender"] as! String
        location = info["location"] as! String
        latitude = info["latitude"] as! Double
        longitude = info["longitude"] as! Double
        password = info["password"] as! String
        self.uid = uid
    }
}


