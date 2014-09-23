//
//  SelectFilterCell.swift
//  yelp
//
//  Created by Sam Mueller on 9/22/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

@objc class SelectFilterCell: UITableViewCell, FilterViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func forFilter(filter: Filter) {
        name.text = filter.name
    }

}
