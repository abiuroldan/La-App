//
//  AlreadyUserCell.swift
//  La App
//
//  Created by Abiú on 1/30/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import UIKit

class AlreadyUserCell: UITableViewCell {
    
    var contact: Contact!{
        didSet{
            nameLabel.text = contact.name + " " + contact.lastName
            phoneLabel.text = contact.phoneNumber
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    //MARK: - UI
    func setupViews(){
        addSubview(nameLabel)
        addSubview(phoneLabel)
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 25).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 25).isActive = true
        phoneLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        phoneLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
