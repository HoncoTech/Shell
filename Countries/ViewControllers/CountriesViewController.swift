//
//  CountriesViewController.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import UIKit
import Siesta


class CountriesViewController: UITableViewController {
    
    var items = [Country]()
    
    
    var resource : Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            resource?.addObserver(self).loadIfNeeded()
        }
    }
    
    
    lazy var searchController : UISearchController = {
       let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.definesPresentationContext = true
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchResultsUpdater = self
        return controller
    }()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.titleView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        
        let footerView = UIView(frame: .zero)
        footerView.backgroundColor = self.tableView.backgroundColor
        self.tableView.tableFooterView = footerView
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryViewCell
        
        // Configure the cell...
        let item = self.items[indexPath.row]
        cell.nameLabel.text = item.name
        cell.iconView.thumbnail(country: item)
        return cell
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let navigationController = segue.destination as? UINavigationController, let viewController = navigationController.topViewController as? CountryViewController, let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        viewController.country = self.items[indexPath.row]
    }
    
    
}


extension CountriesViewController : ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        // If there were a type mismatch, typedContent() would return nil. (We could also provide a default value with
        // the ifNone: param.)
        //print(self.resource?.latestError?.cause., event)
        self.items = self.resource?.typedContent() ?? []
        switch event {
        case .error:
            guard let error = self.resource?.latestError?.cause as NSError?, error.domain == "NSURLErrorDomain", error.code == -1009 else {
               self.tableView.reloadData()
                return
            }
            guard let text = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased(), text.count > 0 else {
               self.tableView.reloadData()
                return
            }
            self.items = APIManager.default.savedCountry.filter({ $0.name.lowercased().contains(text)})
        default:()
        }
        self.tableView.reloadData()
    }
}


extension CountriesViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), text.count > 0 else {
            self.items = []
            self.tableView.reloadData()
            return
        }
        self.resource = APIManager.default.country(text)
        
    }
    
    
}
