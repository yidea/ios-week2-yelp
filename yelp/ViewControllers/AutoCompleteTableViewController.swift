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
    var searchController: SearchController?
    var searchTerm = ""
    
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
        searchController!.updateText(searchTerm)
        updateSearchResultsForSearchController(searchController!)
        println(__FUNCTION__)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        updateSearchResultsForSearchController(searchController!)
        viewController.view.addSubview(self.tableView)
        tableView.hidden = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
        updateSearchResultsForSearchController(searchController!)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(searchController!.searchBar.text)
        viewController.forSearchTerm(searchController!.searchBar.text, filters: nil)
        searchController?.searchBar.resignFirstResponder()
        tableView.hidden = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchArray.removeAll(keepCapacity: false)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        } else {
            
            if (self.searchTerm != "") {
                println(searchTerm)
                yelpClient.search(searchTerm, { (data: Array<String>) in
                    println(data)
                    self.searchArray += data
                })
            }
        }
        self.tableView.reloadData()
    }
}
