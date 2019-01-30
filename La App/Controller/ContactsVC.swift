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
    let newCellID = "newCellID"
    
    let testOne = Contact(name: "Steve", lastName: "Jobs", phoneNumber: "9342339384", isUser: true, contact: nil)
    let testTwo = Contact(name: "Wozniac", lastName: "asdnflsad", phoneNumber: "234134234", isUser: true, contact: nil)
    
    var userLaApp = [Contact]()
    var contactsArray = [Contact]()
    var fullContactArray = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current() // create a locale collation object, by which we can get section index titles of current locale. (locale = local contry/language)
    var sectionTitles = [String]()
    
//    var contactsArray = [Contact]()
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupNavItems()
        setupSearchController()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        contactsArray.append(testOne)
//        contactsArray.append(testTwo)
//        fullContactArray.append(contactsArray)
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
//                self.contactsArray.removeAll()
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                request.sortOrder = .givenName
                
                do{
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        var userBool = false
                        if contact.givenName == self.testOne.name && contact.familyName == self.testOne.lastName{
                            userBool = true
                        }else{
                            userBool = false
                        }
                        debugPrint("Userboll: ", userBool)
                        let contactToAdd = Contact(name: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "", isUser: userBool, contact: contact)
                        
                        if userBool{
                            self.userLaApp.append(contactToAdd)
                        }else{
                            self.contactsArray.append(contactToAdd)
                        }
                        
                        
                    })
                    if self.userLaApp.count != 0{
                        self.fullContactArray.append(self.userLaApp)
                    }
                    
                    self.fullContactArray.append(self.contactsArray)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
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
        searchController.searchBar.placeholder = "Search by number or phone"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - TableView Methods
    func setupTableView(){
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        tableView.register(AlreadyUserCell.self, forCellReuseIdentifier: newCellID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fullContactArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullContactArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Header"
        return label
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentContact = fullContactArray[indexPath.section][indexPath.row]
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: newCellID, for: indexPath) as! AlreadyUserCell
            cell.contact = currentContact
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
            cell.contact = currentContact
            return cell
        }
        
        
        
//        let name = indexPath.section == 0 ? "Is user" : currentContact.name
//        let name = (currentContact.contact?.givenName ?? "") + " " + (currentContact.contact?.familyName ?? "")
        
        
        
        /*var cell = UITableViewCell()
        if currentContact.isUser{
            
        }else{
            let newCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
            newCell.contactName.text = currentContact.name
            cell = newCell
//        cell.detailTextLabel?.text = currentContact.isUser ? currentContact.phoneNumber : ""
            
        }
        return cell*/
    }
}

extension ContactsVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
