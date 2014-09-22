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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        let cred = YelpCredentials()
        super.init(baseURL: NSURL(string: host), consumerKey: cred.key, consumerSecret: cred.keySecret)
    }
    
    func search(term:String) -> Dictionary<String, Int> {
        let params = [
            "term": term,
            "location": "San Francisco"
        ]
        
        GET("search", parameters: params,
            success: { (task: NSURLSessionDataTask!, data: AnyObject!) in
                println(data)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
        })
        
        return Dictionary<String, Int>()
    }
}
