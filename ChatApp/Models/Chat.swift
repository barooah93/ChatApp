//
//  Chat.swift
//  ChatApp
//
//  Created by Brandon Barooah on 1/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class Chat {

    var userName : String?
    var text : String?
    var datePosted:String?
    
    init(userName:String, text:String,datePosted:String) {
        self.userName = userName
        self.text = text
        self.datePosted = datePosted
    }
}
