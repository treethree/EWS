//
//  ChatInfo.swift
//  EWS
//
//  Created by SHILEI CUI on 4/16/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

struct ChatInfo {
    let message : String
    let receiverID : String
    let time : TimeInterval
    
    init(msg: String, receiver: String, time: TimeInterval = Date().timeIntervalSince1970) {
        message = msg
        receiverID = receiver
        self.time = time
    }
    
    init(info: [String : Any]) {
        message = info["message"] as! String
        receiverID = info["receiverID"] as! String
        time = TimeInterval(info["time"] as! String)!
    }
    
    static func <(left: ChatInfo, right: ChatInfo) -> Bool {
        return left.time < right.time
    }
    
    static func >(left: ChatInfo, right: ChatInfo) -> Bool {
        return left.time > right.time
    }
}

