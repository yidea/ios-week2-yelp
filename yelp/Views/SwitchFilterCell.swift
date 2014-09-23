//
//  FilterCell.swift
//  yelp
//
//  Created by Sam Mueller on 9/22/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

@objc class SwitchFilterCell: UITableViewCell, FilterViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var switchbox: UISwitch!
    var filter = Filter(name: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func forFilter(filter: Filter) {
        self.filter = filter
        name.text = filter.name
        switchbox.setOn(filter.selected, animated: true)
    }
    
    @IBAction func onSwitchChanged(sender: AnyObject) {
        self.filter.selected = switchbox.on
    }
}

@objc protocol FilterViewCell {
    func forFilter(filter: Filter)
}
