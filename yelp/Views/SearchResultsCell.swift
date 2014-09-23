//
//  SearchResultsCell.swift
//  yelp
//
//  Created by Sam Mueller on 9/21/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import UIKit

class SearchResultsCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var stars: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var categories: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumb.layer.cornerRadius = thumb.frame.size.width / 2;
        thumb.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func forBusiness(biz: Business) {
        titleCell.text = biz.name
        reviews.text = biz.reviewFormatted
        categories.text = biz.categoriesFormatted
        if biz.thumbUrl != nil {
            thumb.setImageWithURL(NSURL(string: biz.thumbUrl!))
        }
        stars.setImageWithURL(NSURL(string: biz.ratingImageUrl))
    }

}
