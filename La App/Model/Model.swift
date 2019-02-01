//
//  Model.swift
//  La App
//
//  Created by Abiu Roldán on 1/29/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import Foundation
import Contacts

@objc class Contact: NSObject {
    @objc var name: String
    var lastName: String
    var phoneNumber: String
    var contact: CNContact?
    var isUser: Bool = false
    
    init(name: String, lastName: String, phoneNumber: String, isUser: Bool, contact: CNContact?) {
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.isUser = isUser
        self.contact = contact
    }
}
