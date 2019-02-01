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

class ContactsVC: UITableViewController {
    
    //MARK: - Variables
    let searchController = UISearchController(searchResultsController: nil)
    let cellID = "cellID"
    let newCellID = "newCellID"
    
    let testOne = Contact(name: "Steve", lastName: "Jobs", phoneNumber: "(554) 323-4376", isUser: true, contact: nil)
    let testTwo = Contact(name: "Sean", lastName: "Allen", phoneNumber: "(234) 134-2334", isUser: true, contact: nil)
    
    var userLaApp = [Contact]()
    var contactsArray = [Contact]()
    var fullContactArray = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current() // create a locale collation object, by which we can get section index titles of current locale. (locale = local contry/language)
    var sectionTitles: [String] = ["Usuario", "Contactos", "Otros"]
    
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
//                self.contactsArray.removeAll()
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactNameSuffixKey, CNContactImageDataAvailableKey, CNContactImageDataKey, CNContactThumbnailImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                request.sortOrder = .givenName
                
                do{
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        if let imageData = contact.thumbnailImageData {
                            print("image \(String(describing: UIImage(data: imageData)))")
                        } else {
                            print("No image available")
                        }
                        
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
                        debugPrint("Userboll: ", userBool)
                        let contactToAdd = Contact(name: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "", isUser: userBool, contact: contact)
                        
                        //If is true the contact will be save in La App array user
                        if userBool{
                            self.userLaApp.append(contactToAdd)
                        }else{
                            //All contacts that are not La App users
                            self.contactsArray.append(contactToAdd)
                        }
                    })
                    
                    //If the array "userLaApp" is not empty will be add it to the full array
                    /*if self.userLaApp.count != 0{
                        self.fullContactArray.append(self.userLaApp)
                    }*/
                    self.fullContactArray.append(self.userLaApp)
                    self.fullContactArray.append(self.contactsArray)
                    debugPrint("self.full: ", self.fullContactArray)
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
    
    @objc func setUpCollation(){
        let (arrayContacts, arrayTitles) = collation.partitionObjects(array: self.contactsArray, collationStringSelector: #selector(getter: Contact.name))
//        self.contactsWithSections = arrayContacts as! [[Contact]]
        debugPrint("arrayContacts: ", arrayContacts.map{$0})
        self.sectionTitles = arrayTitles
        
        print(fullContactArray.count)
        print(sectionTitles.count)
    }
    
    //Setup search controller on tableView
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search by name or phone"
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
    
    /*override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Header"
        return label
    }*/
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    /*override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }*/
    
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

extension ContactsVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
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
