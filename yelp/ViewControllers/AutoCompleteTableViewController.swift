//
//  AutoCompleteTableViewController.swift
//  yelp
//
//  Created by Sam Mueller on 9/21/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

class AutoCompleteTableViewController: UITableViewController, UISearchResultsUpdating {

    var searchArray = [String]()
    let yelpClient = YelpClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return searchArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AutoCompleteCell", forIndexPath: indexPath) as AutoCompleteCell
        
        cell.titleLabel.text = searchArray[indexPath.row]

        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var searchTerm = searchController.searchBar.text
        searchArray.removeAll(keepCapacity: false)
        if (searchTerm != "") {
            yelpClient.search(searchTerm, { (data: Array<String>) in
                self.searchArray += data
                self.tableView.reloadData()
            })
        }
//        searchArray.removeAll(keepCapacity: false)
        
//        for country:String in countryArray
//        {
//            var searchText = searchController.searchBar.text
//            
//            if NSString(string: country.lowercaseString).containsString(searchText.lowercaseString)
//            {
//                searchArray.append(country)
//            }
//        }
//        
//        tableView.reloadData()
    }
}
