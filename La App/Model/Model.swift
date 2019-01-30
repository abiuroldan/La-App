//
//  Model.swift
//  La App
//
//  Created by Abiu Roldán on 1/29/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import Foundation

@objc class Contact: NSObject {
    @objc var name: String
    @objc var phoneNumber: String
    @objc var isUser: Bool = false
    
    init(name: String, phoneNumber: String, isUser: Bool) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.isUser = isUser
    }
}
