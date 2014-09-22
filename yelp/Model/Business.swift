//
//  Business.swift
//  yelp
//
//  Created by Sam Mueller on 9/22/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import Foundation

struct Business {
    
    let id: String
    let name: String
    let phone: String?
    let isClosed: Bool
    let ratingImageUrl: String
    let reviewCount: Int
    let snippetImageUrl: String?
    //let menuUpdatedOn:
    let rating: Double
    var categories = [NSString]()
    var thumbUrl: String?
    
    init(id: String, name: String, phone: String?, isClosed: Bool, ratingImageUrl: String, reviewCount: Int, snippetImageUrl: String?, rating: Double, categories: [NSString], thumbUrl: String?) {
        self.id = id
        self.name = name
        self.phone = phone
        self.isClosed = isClosed
        self.ratingImageUrl = ratingImageUrl
        self.reviewCount = reviewCount
        self.snippetImageUrl = snippetImageUrl
        self.rating = rating
        self.categories = categories
        self.thumbUrl = thumbUrl
    }
    
    var reviewFormatted : String {
        get {
            return "\(reviewCount) reviews"
        }
    }
    
    var categoriesFormatted : String {
        get {
            return categories.combine(", ")
        }
    }
}

struct BusinessKeys {
    
    //TODO: Migrate to a deserializer
    let idKey = "id"
    let nameKey = "name"
    let phoneKey = "phone_display"
    let isClosedKey = "is_closed"
    let ratingImageUrlKey = "rating_img_url"
    let reviewCountKey = "review_count"
    let snippetImageUrlKey = "snippet_image_url"
    //let menuUpdatedOn:
    let ratingKey = "rating"
    var categoriesKey = "categories"
    var thumbUrlKey = "image_url"
}

extension Array {
    
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}