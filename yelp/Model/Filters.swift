//
//  Filters.swift
//  yelp
//
//  Created by Sam Mueller on 9/22/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import Foundation

class FilterBase {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}


@objc class Filter : FilterBase {
    var type: String?
    var selected = false
    var supported = false
    var key = ""
    var value = ""
}

class Section : FilterBase {
    var filters = [Filter]()
    var expanded = false
    var isExpansionLocked = false
}

class FilterRepository {
    
    //sections that contain all the filters
    var sections = [Section]()
    var filters = [Filter]() //convenience flattened array for table index lookups
    
    init() {
        populateFromJson()
    }
    
    func populateFromJson() {
        var error: NSError?
        var filePath = NSBundle.mainBundle().pathForResource("Filters", ofType: ".json")
        var data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: nil)
        var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as NSArray
        for item in json {
            if let hash = item as? Dictionary<String, NSObject> {
                let section = Section(name: hash["name"] as NSString)
                section.isExpansionLocked = (hash["isExpansionLocked"] as NSNumber).boolValue
                let filtersArray = hash["filters"] as? NSArray
                if let filters = filtersArray as? Array<NSDictionary> {
                    for filterHash in filters {
                        let filter = Filter(name: filterHash["name"] as NSString)
                        filter.type = filterHash["type"] as NSString
                        filter.supported = filterHash["supported"] as Bool
                        filter.key = filterHash["key"] as NSString
                        filter.value = filterHash["value"] as NSString
                        section.filters.append(filter)
                    }
                    self.filters += section.filters
                }
                sections.append(section)
            }
        }
    }
}