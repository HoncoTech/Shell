//
//  CountryViewController.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {
    
    
    var country : Country?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = self.country?.name
        let footerView = UIView(frame: .zero)
        footerView.backgroundColor = self.tableView.backgroundColor
        self.tableView.tableFooterView = footerView
        
        
        guard let item = self.country,  APIManager.default.savedCountry.filter({ $0.alpha3Code == item.alpha3Code}).count == 0 else {
            return
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func saveTapped() {
        guard let item = self.country else {
            return
        }
        APIManager.default.add(country: item)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard self.country != nil else {
            return 0
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section != 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath) as! ImageViewCell
            
            // Configure the cell...
            cell.iconView.fullImage(country: self.country!)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailViewCell
        switch indexPath.section {
        case 1:
            cell.nameLabel.text = "Native Name"
            cell.valueLabel.text = self.country?.nativeName
        case 2:
            cell.nameLabel.text = "Capital"
            cell.valueLabel.text = self.country?.capital
        case 3:
            cell.nameLabel.text = "Region"
            cell.valueLabel.text = self.country?.region
        case 4:
            cell.nameLabel.text = "Sub-Region"
            cell.valueLabel.text = self.country?.subregion
        case 5:
            cell.nameLabel.text = "Phone Codes"
            cell.valueLabel.text = self.country?.callingCodes.joined(separator: ", ")
        case 6:
            cell.nameLabel.text = "Population"
            cell.valueLabel.text = String(format: "%d", self.country?.population ?? 0)
        case 7:
            cell.nameLabel.text = "Time Zone" + ((self.country?.timezones ?? []).count > 1  ? "s" : "")
            cell.valueLabel.text = (self.country?.timezones ?? []).joined(separator: ", ")
        case 8:
            cell.nameLabel.text = "Language" + ((self.country?.languages ?? []).count > 1  ? "s" : "")
            cell.valueLabel.text = (self.country?.languages ?? []).compactMap({ $0.nativeName }).joined(separator: ", ")
        case 9:
            cell.nameLabel.text = "Currency"
            cell.valueLabel.text = (self.country?.currencies ?? []).compactMap({ $0.name }).joined(separator: ", ")
        default:
            cell.nameLabel.text = nil
            cell.valueLabel.text = nil
        }
        
        // Configure the cell...
        return cell
    }
    
}
