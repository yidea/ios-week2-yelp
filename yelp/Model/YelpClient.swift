//
//  YelpClient.swift
//  yelp
//
//  Created by Sam Mueller on 9/20/14.
//  Copyright (c) 2014 Sam Mueller. All rights reserved.
//

import Foundation

class YelpClient: BDBOAuth1SessionManager {
    
    let host = "http://api.yelp.com/v2/"
    let categoryUrl = "http://raw.githubusercontent.com/Yelp/yelp-api/master/category_lists/en/category.json"
    var categories: [String] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateCategories() {
        var error: NSError?
        var filePath = NSBundle.mainBundle().pathForResource("Categories", ofType: ".json")
        var data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: nil)
        var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as NSArray
        for item in json {
            if let cat = item as? NSDictionary {
                categories.append(cat["title"] as String)
            }
        }
    }
    
    override init() {
        //let cred = YelpCredentials()
        
        let key = "P4uOp_1oLLTO5FWUl5GuQQ"
        let keySecret = "U-0L89eep-7sbJsPgDI4sYN-qss"
        let token = "enUxUnYmqN7mDTPSOysP9cpLUgpqxNmi"
        let tokenSecret = "Q5IVsfR6Y4dkWoALQW_HME5ZtxA"
        
        super.init(baseURL: NSURL(string: host), consumerKey: key, consumerSecret: keySecret)
        let bToken = BDBOAuthToken(token: token, secret: tokenSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(bToken)
        populateCategories()
    }
    
    override init(baseURL url: NSURL!, sessionConfiguration configuration: NSURLSessionConfiguration!) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }
    
    func search(term:String, completion: (data: Array<String>) -> Void) -> Void {
        
        if (term.utf16Count <= 3) {
            categories(term, completion: completion)
        } else {
            //businesses(term, completion: completion)
        }
    }
    
    func categories(term:String, completion: (data: Array<String>) -> Void) -> Void {
        var results: [String] = []
        for cat in categories {
            if startsWith(cat, term) {
                results.append(cat)
            }
        }
        completion(data: results)
    }
    
    
    func businesses(term:String, filters: FilterRepository?, completion: (data: Array<Business>) -> Void) -> Void {
        
        var params = [
            "term": term,
            "location": "San Francisco"
        ]
        
        if filters != nil {
            for f in filters!.filters {
                if f.selected && f.supported {
                    params[f.key] = f.value
                }
            }
        }
        
        println(params)
        
        GET("search", parameters: params,
            success: { (task: NSURLSessionDataTask!, data: AnyObject!) in
                var businesses = (data as NSDictionary)["businesses"] as NSArray
                var data = [Business]()
                var keys = BusinessKeys()
                for item in businesses {
                    if let hash = item as? Dictionary<String, NSObject> {
                        
                        var categories = [String]()
                        //extract categories from nested arrays
                        if hash[keys.categoriesKey] != nil {
                            let catArray = hash[keys.categoriesKey]! as [NSArray]
                            for catSubarray in catArray {
                                categories.append(catSubarray[0] as NSString)
                            }
                        }
                        
                        var business = Business(
                            id: hash[keys.idKey]! as String,
                            name: hash[keys.nameKey]! as String,
                            phone: hash[keys.phoneKey] as? NSString,
                            isClosed: hash[keys.isClosedKey]! as Bool,
                            ratingImageUrl: hash[keys.ratingImageUrlKey]! as String,
                            reviewCount: hash[keys.reviewCountKey]! as Int,
                            snippetImageUrl: hash[keys.snippetImageUrlKey] as? NSString,
                            rating: hash[keys.ratingKey]! as Double,
                            categories: categories,
                            thumbUrl: hash[keys.thumbUrlKey] as? NSString
                        )
                        data.append(business)
                    }
                }
                completion(data: data)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
        })
    }
}

enum ResultType {
    case Category
    case Business
}
