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
            let name = contact.contact?.givenName ?? contact.name
            let lastName = contact.contact?.familyName ?? contact.lastName
            let suffix = contact.contact?.nameSuffix ?? ""
            contactName.text = name + " " + lastName + " " + suffix
            
            if let imageData = contact.contact?.thumbnailImageData {
                imageUser.image = UIImage(data: imageData)
            } else {
                imageUser.image = #imageLiteral(resourceName: "user")
            }
        }
    }

    let imageUser: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let contactName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageUser.layer.cornerRadius = imageUser.frame.height / 2
    }
    
    //MARK: - UI
    func setupViews(){
        addSubview(imageUser)
        addSubview(contactName)
        
        let imageSize: CGFloat = frame.height
        imageUser.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageUser.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 13).isActive = true
        imageUser.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        imageUser.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageUser.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        contactName.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        contactName.leadingAnchor.constraint(equalTo: imageUser.trailingAnchor, constant: 15).isActive = true
        contactName.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        contactName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
