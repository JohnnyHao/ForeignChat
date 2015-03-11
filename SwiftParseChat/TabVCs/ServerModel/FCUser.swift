//
//  FCUser.swift
//  ForeignChat
//
//  Created by Tonny.hao on 3/11/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/25724955/swift-parse-subclass-dynamic-var-dont-get-included-when-retrieving-object

class FCUser : PFUser, PFSubclassing {
    
    @NSManaged var friends:[FCUser]?
    @NSManaged var fullName:String?
    @NSManaged var gender:NSNumber?
    
    @NSManaged var picture:PFFile?
    @NSManaged var thumbnail:PFFile?
    
    override class func load() {
        self.registerSubclass()
    }

}