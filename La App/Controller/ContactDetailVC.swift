//
//  ContactDetailVC.swift
//  La App
//
//  Created by Abiú on 1/31/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import UIKit
import Contacts

class ContactDetailVC: UIViewController {

    var contactSelected: Contact?
    
    override func loadView() {
        super.loadView()
        setupNavItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    //MARK: - UI
    //Navigation Items
    func setupNavItems(){
        let name = contactSelected?.contact?.givenName ?? contactSelected?.name
        let lastName = contactSelected?.contact?.familyName ?? contactSelected?.lastName
        navigationItem.title = (name ?? "") + " " + (lastName ?? "")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
