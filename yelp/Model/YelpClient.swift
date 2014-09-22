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
        println(filePath)
        var data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: nil)
        var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as NSArray
        for item in json {
            if let cat = item as? NSDictionary {
                categories.append(cat["title"] as String)
            }
        }
        println(categories)
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
            var results: [String] = []
            for cat in categories {
                if startsWith(cat, term) {
                    results.append(cat)
                }
            }
            completion(data: results)
        } else {
            let params = [
                "term": term,
                "location": "San Francisco"
            ]
            
            GET("search", parameters: params,
                success: { (task: NSURLSessionDataTask!, data: AnyObject!) in
                    var businesses: AnyObject? = (data as NSDictionary)["businesses"]
                    println(businesses)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    println(error)
            })
        }
    }
}

enum ResultType {
    case Category
    case Business
}
