//
//  Password.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 3/6/16.
//  Copyright © 2016 Rose-Hulman. All rights reserved.
//

import UIKit

class Password {
    
    var key : String!
    var service : String!
    var username : String?
    var password : String!
    
    convenience init() {
        self.init(service: "Rose-Hulman", username: "rockwotj", password: "foobar")
    }
    
    convenience init(json : [String : AnyObject]) {
        self.init(service: json["service"] as! String,
            username: json["username"] as? String,
            password: json["password"] as! String)
    }

    init(service: String!, username: String?, password: String!) {
        self.service = service
        self.username = username
        self.password = password
    }
    
}
