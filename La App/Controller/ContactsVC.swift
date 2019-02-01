//
//  ViewController.swift
//  La App
//
//  Created by Abiu Roldán on 1/29/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

var allContacts = [Contact]()

class ContactsVC: UITableViewController {
    
    //MARK: - Variables
    let searchController = UISearchController(searchResultsController: SearchTVC())
    let cellID = "cellID"
    let newCellID = "newCellID"
    
    let testOne = Contact(name: "Steve", lastName: "Jobs", phoneNumber: "(554) 323-4376", isUser: true, contact: nil)
    let testTwo = Contact(name: "Sean", lastName: "Allen", phoneNumber: "(234) 134-2334", isUser: true, contact: nil)
    
    var userLaApp = [Contact]()
    var contactsArray = [Contact]()
    var fullContactArray = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current() // create a locale collation object, by which we can get section index titles of current locale. (locale = local contry/language)
    var sectionTitles: [String] = ["User"]
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupNavItems()
        setupSearchController()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        fetchContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
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
                self.cleanAll()
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactNameSuffixKey, CNContactImageDataAvailableKey, CNContactImageDataKey, CNContactThumbnailImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                request.sortOrder = .givenName
                
                do{
//                   self.cleanAll()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        //Verify is already La App user
                        var userBool = false
                        if let phone = contact.phoneNumbers.first?.value.stringValue{
                            if phone == self.testOne.phoneNumber || phone == self.testTwo.phoneNumber{
                                userBool = true
                            }else{
                                userBool = false
                            }
                        }else{
                            userBool = false
                        }
                        
                        let contactToAdd = Contact(name: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "", isUser: userBool, contact: contact)
                        
                        //If is true the contact will be save in La App array user
                        allContacts.append(contactToAdd)
                        if userBool{
                            self.userLaApp.append(contactToAdd)
                        }else{
                            //All contacts that are not La App users
                            self.contactsArray.append(contactToAdd)
//                            self.fullContactArray.append([contactToAdd])
                        }
                    })
                    
                    //If the array "userLaApp" is not empty will be add it to the full array
                    /*if self.userLaApp.count != 0{
                        self.fullContactArray.append(self.userLaApp)
                    }*/
                    self.fullContactArray.append(self.userLaApp)
                    self.setUpCollation()
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
    
    func cleanAll(){
        fullContactArray.removeAll()
        contactsArray.removeAll()
        userLaApp.removeAll()
        sectionTitles.removeAll()
        sectionTitles.append("User")
        allContacts.removeAll()
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground(_ notification: NSNotification){
        fetchContacts()
    }
    
    @objc func setUpCollation(){
        let (arrayContacts, arrayTitles) = collation.partitionObjects(array: self.contactsArray, collationStringSelector: #selector(getter: Contact.name))
        for item in arrayTitles{
            self.sectionTitles.append(item)
        }
        
        for contactItem in arrayContacts{
            self.fullContactArray.append(contactItem as! [Contact])
        }
    }
    
    //Setup search controller on tableView
    func setupSearchController(){
        let searchView = SearchTVC()
        searchController.searchResultsUpdater = searchView
        searchController.searchBar.placeholder = "Search by name or phone"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentContact = fullContactArray[indexPath.section][indexPath.row]
        if self.userLaApp.count != 0{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: newCellID, for: indexPath) as! AlreadyUserCell
                cell.contact = currentContact
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
                cell.contact = currentContact
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
            cell.contact = currentContact
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentContact = fullContactArray[indexPath.section][indexPath.row]
        if currentContact.isUser{
            if let navController = navigationController{
                let contactView = ContactDetailVC()
                contactView.contactSelected = currentContact
                navController.pushViewController(contactView, animated: true)
            }
        }else{
            debugPrint("No es usuario, mandar mensaje")
            sendMessage()
        }
    }
    
    func sendMessage(){
        if MFMessageComposeViewController.canSendText() {
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.body = "text"
            present(messageComposeViewController, animated: true, completion: nil)
        }else{
            
        }
        
        
        /*let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
//        messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self
        
        self.present(messageVC, animated: true, completion: nil)*/
    }
}

extension ContactsVC: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}

extension ContactsVC: UISearchBarDelegate{
    
}
