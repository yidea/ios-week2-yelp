//
//  SearchController.swift
//  yelp
//
//  Created by Samuel Mueller on 9/23/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    var customUISearchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesNavigationBarDuringPresentation = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateText(text: String) {
        println(__FUNCTION__ + customUISearchBar!.text + "compares to" + text)
        customUISearchBar!.text = text
    }
    
    override var searchBar: UISearchBar {
        get {
            if customUISearchBar == nil {
                println("instantiating")
                customUISearchBar = UISearchBar()
                customUISearchBar!.showsCancelButton = false
            }
            return customUISearchBar!
        }
    }
}
