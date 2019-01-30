//
//  ViewController.swift
//  La App
//
//  Created by Abiu Roldán on 1/29/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import UIKit
import Contacts

class ContactsVC: UITableViewController {
    
    //MARK: - Variables
    let searchController = UISearchController(searchResultsController: nil)
    let cellID = "cellID"
    
    var contactsArray = [Contact]()
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupNavItems()
        setupSearchController()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //MARK: - Methods
    //Request and setup access contacts
    private func fetchContacts(){
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access: ", err)
                return
            }
            
            if granted{
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do{
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        self.contactsArray.append(Contact(name: contact.givenName + " " + contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "", isUser: false))
                    })
                    
                    self.tableView.reloadData()
                    
                }catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
                
            }else{
                print("Access denied...")
            }
        }
    }
    
    //Setup navigation items
    func setupNavItems(){
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - UI
    //Adding view
    func setupViews(){
        
    }
    
    //Setup Layout
    func setupLayout(){
        
    }
    
    //Setup search controller on tableView
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - TableView Methods
    func setupTableView(){
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
//        let currentContact = contactsArray[indexPath.row]
//        cell.detailTextLabel?.text = currentContact.isUser ? currentContact.phoneNumber : ""
        return cell
    }
    
}

extension ContactsVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
