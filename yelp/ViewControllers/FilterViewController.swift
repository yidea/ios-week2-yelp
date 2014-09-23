//
//  FilterViewController.swift
//  yelp
//
//  Created by Sam Mueller on 9/22/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    let repository = FilterRepository()
    var completion: ((repository: FilterRepository?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return repository.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = repository.sections[section]
        return (s.expanded || s.isExpansionLocked) ? s.filters.count : 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return repository.sections[section].name
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let s = repository.sections[indexPath.section]
        
        var rowIndex = indexPath.row
        
        //when not expanded, we must ensure we return the selected filter
        if !s.expanded && !s.isExpansionLocked {
            for f in s.filters {
                if f.selected {
                    rowIndex = (s.filters as NSArray).indexOfObject(f)
                }
            }
        }
        
        let filter = s.filters[rowIndex]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(filter.type!, forIndexPath: indexPath) as UITableViewCell
        
        //All cells should implement this protocol
        (cell as FilterViewCell).forFilter(filter)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let s = repository.sections[indexPath.section]

        //take action if this a section can be expanded or collapsed
        if !s.isExpansionLocked {
            s.expanded = !s.expanded
            
            //clear out any selected rows
            for f in s.filters {
                f.selected = false
            }
        }
        

        
        //now persist the one that has just been selected
        s.filters[indexPath.row].selected = true
        tableView.reloadData()
    }
    
    //will return a nil repository if modal was canceled
    func forSearch(completion: ((repository: FilterRepository?) -> Void)) {
        self.completion = completion
    }
    
    @IBAction func onSearchClick(sender: AnyObject) {
        closeAndCallback(self.repository)
    }
    
    @IBAction func onCancelClick(sender: UIBarButtonItem) {
        closeAndCallback(nil)
    }
    
    func closeAndCallback(rep: FilterRepository?) {
        dismissViewControllerAnimated(true, { })
        if let c = completion {
            c(repository: rep)
        }
    }

}
