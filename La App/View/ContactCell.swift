//
//  ContactCell.swift
//  La App
//
//  Created by Abiu Roldán on 1/30/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var contact: Contact! {
        didSet{
            contactName.text = contact.name + " " + contact.lastName
        }
    }

    let contactName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    //MARK: - UI
    func setupViews(){
        addSubview(contactName)
        
        contactName.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        contactName.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 25).isActive = true
        contactName.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        contactName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
