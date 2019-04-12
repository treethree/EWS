//
//  PostData.swift
//  EWS
//
//  Created by SHILEI CUI on 4/12/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

class PostsData {
    var description: String
    var imageRef: String
    var likeCount: Int
    var userName: String
    var postId: String
    var userId: String
    var timeStamp: Double
    
    init(des: String , imgRef: String , likes: Int , usr: String, pid: String, usrId: String, time: Double) {
        description = des
        imageRef = imgRef
        likeCount = likes
        userName = usr
        postId = pid
        userId = usrId
        timeStamp = time
    }
}
