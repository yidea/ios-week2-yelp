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
    @IBOutlet weak var filterBar: UIView!
    var searchResults = [Business]()
    var searchController = UISearchController()
    let yelpClient = YelpClient()
    var currentSearchTerm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        filterBar.hidden = true
        
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
        let biz = searchResults[indexPath.row]
        cell.forBusiness(biz)
        return cell
    }
    
    func forSearchTerm(searchTerm: String, filters: FilterRepository?) {
        searchResults.removeAll(keepCapacity: false)
        yelpClient.businesses(searchTerm, filters: filters, completion: { (data: Array<Business>) in
            self.searchResults += data
            self.tableView.reloadData()
            self.filterBar.hidden = false
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        if segue.identifier == "FilterOptions" {
            println(segue.sourceViewController)
            println(segue.destinationViewController)
            let nc = segue.destinationViewController as UINavigationController
            let vc = nc.viewControllers[0] as FilterViewController
            vc.forSearch({ (repo: FilterRepository?) in
                if repo != nil {
                    println(self.searchController.searchBar.text)
                    self.forSearchTerm(self.searchController.searchBar.text, filters: repo)
                } else {
                    self.tableView.reloadData()
                }
            })
        }
    }

}
