//
//  FCUser.swift
//  ForeignChat
//
//  Created by Tonny.hao on 3/11/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation


class FCUser : PFUser, PFSubclassing {
    
    @NSManaged var friends:[FCUser]?
    @NSManaged var fullName:String
    @NSManaged var gender:NSNumber
    
    override class func load() {
        self.registerSubclass()
    }
    
//    override class func parseClassName() -> String! {
//        return PF_USER_CLASS_NAME
//    }
}