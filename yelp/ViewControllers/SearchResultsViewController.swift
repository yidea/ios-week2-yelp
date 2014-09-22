//
//  SearchViewController.swift
//  yelp
//
//  Created by Sam Mueller on 9/21/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet var tableView: UITableView!
    var searchResults = ["Love", "Me"]
    var searchController = UISearchController()
    let yelpClient = YelpClient()
    var currentSearchTerm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.searchController = ({
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let autocompleteController = storyBoard.instantiateViewControllerWithIdentifier("AutoCompleteViewController") as AutoCompleteTableViewController
            autocompleteController.viewController = self
            let controller = UISearchController(searchResultsController: autocompleteController)
            controller.searchResultsUpdater = autocompleteController
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.definesPresentationContext = false
            controller.searchBar.delegate = autocompleteController
            controller.searchBar.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 44.0)
            //self.tableView.tableHeaderView = controller.searchBar
            self.navItem.titleView = controller.searchBar
            controller.delegate = self
            return controller
        })()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        println(searchController.searchBar.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return searchResults.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as SearchResultsCell
        cell.titleCell.text = searchResults[indexPath.row]
        return cell
    }
    
    func forSearchTerm(searchTerm: String) {
        //searchResults.removeAll(keepCapacity: false)
        yelpClient.businesses(searchTerm, { (data: Array<String>) in
            self.searchResults += data
            println(self.searchResults)
            self.tableView.reloadData()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
