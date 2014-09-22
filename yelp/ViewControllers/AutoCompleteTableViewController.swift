//
//  AutoCompleteTableViewController.swift
//  yelp
//
//  Created by Sam Mueller on 9/21/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

class AutoCompleteTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var searchArray = [String]()
    let yelpClient = YelpClient()
    var viewController = SearchResultsViewController()
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AutoCompleteCell", forIndexPath: indexPath) as AutoCompleteCell
        
        cell.titleLabel.text = searchArray[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchTerm = searchArray[indexPath.row]
        searchController.searchBar.text = searchTerm
        println(__FUNCTION__)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        tableView.hidden = false
        println(__FUNCTION__)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        viewController.forSearchTerm(searchController.searchBar.text)
        tableView.hidden = true
        println(__FUNCTION__)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        println(__FUNCTION__)
        searchArray.removeAll(keepCapacity: false)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        } else {
            self.searchController = searchController
            var searchTerm = searchController.searchBar.text
            
            if (searchTerm != "") {
                yelpClient.search(searchTerm, { (data: Array<String>) in
                    self.searchArray += data
                })
            }
        }
        self.tableView.reloadData()
    }
}
