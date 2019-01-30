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
//                var contactsArray = [Contact]()
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                request.sortOrder = .userDefault
                
                do{
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        self.contactsArray.append(Contact(name: contact.givenName + " " + contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "", isUser: false))
                    })
                    
                    
                    for index in self.contactsArray.indices{
                        
                        print(self.contactsArray[index].name)
                        print(self.contactsArray[index].phoneNumber)
                    }
                    
                    self.setUpCollation()
                    
//                    self.fullContactArray.append(self.contactsArray)
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
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - TableView Methods
    func setupTableView(){
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fullContactArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullContactArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentContact = fullContactArray[indexPath.section][indexPath.row]
//        let name = indexPath.section == 0 ? "Is user" : currentContact.name
        let name = currentContact.name
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        cell.contactName.text = name
        return cell
        
        
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
    
    @objc func setUpCollation(){
        let (arrayContacts, arrayTitles) = collation.partitionObjects(array: self.contactsArray as [AnyObject], collationStringSelector: #selector(getter: Contact.name))
        self.fullContactArray = arrayContacts as! [[Contact]]
        self.sectionTitles = arrayTitles
        
        print(fullContactArray.count)
        print(sectionTitles.count)
    }
    
}

extension ContactsVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionObjects(array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()
        
        //1. Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        //2. Put each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        //3. sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count { if unsortedSections[index].count > 0 {
            sectionTitles.append(self.sectionTitles[index])
            sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }
}
