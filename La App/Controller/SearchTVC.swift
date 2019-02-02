//
//  SearchTVC.swift
//  La App
//
//  Created by Abiú on 2/1/19.
//  Copyright © 2019 Abiu Roldán. All rights reserved.
//

import UIKit

class SearchTVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var filteredContacts = [Contact]()
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty{
            filteredContacts = allContacts.filter({ (contact: Contact) -> Bool in
                return contact.name.lowercased().contains(searchText.lowercased()) || contact.phoneNumber.contains(searchText)
            })
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredContacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let currentContact = filteredContacts[indexPath.row]
        let name = (currentContact.contact?.givenName ?? currentContact.name)
        let lastName = (currentContact.contact?.familyName ?? currentContact.lastName)
        let suffix = currentContact.contact?.nameSuffix ?? ""

        cell.textLabel?.text = name + " " + lastName + " " + suffix

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentContact = filteredContacts[indexPath.row]
        
        if currentContact.isUser{
            debugPrint("Es usuario")
        }else{
            debugPrint("No es usuario")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
    */
   
}
