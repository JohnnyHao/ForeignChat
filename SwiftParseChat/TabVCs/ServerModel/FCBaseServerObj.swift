//
//  FCBaseServerObj.swift
//  ForeignChat
//
//  Created by Tonny.hao on 3/11/15.
//  Copyright (c) 2015 JohnnyHao. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/24581981/subclassing-pfobject-in-swift

class FCBaseServerObj : PFObject, PFSubclassing {
    override class func load() {
        self.registerSubclass()
    }
    class func parseClassName() -> String! {
        return "FCBaseServerObj"
    }
    //@NSManaged var Name: String
}