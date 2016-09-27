//
//  GetDBTable.swift
//  CKI App
//
//  Created by Vincent Yeh on 7/26/16.
//  Copyright © 2016 Vincent Bob Yeh. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Item : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
        var Name:String = ""
        var Date:String = ""
        var Location:String = ""
        var Time:String = ""
        var End_Time:String = ""
        var Type:Int=0
        var Description:String=""
        var Participants:[String:[String:String]] = [:]
    
        class func dynamoDBTableName() -> String {
            return "Event"
        }
    
        // if we define attribute it must be included when calling it in function testing...
        class func hashKeyAttribute() -> String {
            return "Name"
        }
    
        class func rangeKeyAttribute() -> String {
            return "Date"
        }

        override func isEqual(object: AnyObject?) -> Bool {
            return super.isEqual(object)
        }
}
