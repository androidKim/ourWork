//
//  family.swift
//  ourWork
//
//  Created by taejun on 12/04/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//

import Foundation
import SwiftyJSON
class family:NSObject{
    var family_key:String  = "";//시퀀스
    var reg_date:String = "";//timestamp
    var member_list:Array = [String]() //가족 멤버키리스트
    
    init(family_key: String?, reg_date:String?, member_list:[String]){
        self.family_key = family_key!
        self.reg_date = reg_date!
        self.member_list = member_list
    }
    
    class func build(json:JSON) -> family?
    {
        let pInfo:family = family(family_key: "", reg_date:"", member_list: [String]());
        pInfo.family_key = json["family_key"].stringValue
        pInfo.reg_date = json["reg_date"].stringValue
        pInfo.member_list = json["member_list"].array as! [String]
        return pInfo
    }
}


