//
//  IshanksSDK.swift
//  Neustar
//
//  Created by Ishank Tandon on 1/22/18.
//  Copyright © 2018 Ishank Tandon. All rights reserved.
//

import Foundation

public class Neustar {
    
    var euid: String
    var tagId: String
    var eventName: String
    var maid: String
    
    let postbackURL: String = "http://d.agkn.com/pixel/"
    var result = ""
    
    public init() {
        self.euid = ""
        self.tagId = ""
        self.eventName = ""
        self.maid = ""
    }
    
    public func setEuid(euid: String) {
        self.euid = euid
    }
    
    public func getEuid() -> String {
        return self.euid
    }
    
    public func setTagId(tagId: String) {
        self.tagId = tagId
    }
    
    public func getTagId() -> String {
        return self.tagId
    }
    
    public func setEventName(eventName: String) {
        self.eventName = eventName
    }
    
    public func getEventName() -> String {
        return self.eventName
    }
    
    public func setMaid(maid: String) {
        self.maid = maid
    }
    
    public func getMaid() -> String {
        return self.maid
    }
    
    public func execute() -> Any {
        let cachebuster = String(Int(drand48()*10000000000))
        
        if self.euid == "" || self.tagId == "" || self.eventName == "" || self.maid == "" {
            return "userId, tagId, eventName, and maId can't be empty or null. Please use the setters to set the value."
        }
        
        let urlStr = self.postbackURL + self.tagId + "/?" + "che=sfjk32kse&event=" + self.eventName + "&rev= 1234.56&qty=2&ordid=abc123def456&maid=" + self.maid + "&euid=" + self.euid + "&umaid=AEBE52E7-03EE-455A-B3C4-E57283966239" + "&cachebuster=" + cachebuster
        
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.result = "Error: \(String(describing: error?.localizedDescription))"
                return
            }
            else if let data = data {
                if let resp = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    self.result = "Response is: " + (resp as String)
                } else {
                    self.result = "Server responded but there was no data. Check headers."
                }
                //                self.result = "Response is: " + (resp! as String)
                
            }
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
        return self.result
    }
    
    
}
