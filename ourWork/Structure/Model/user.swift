//
//  user.swift
//  ourWork
//
//  Created by taejun on 01/04/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//
import Foundation
import SwiftyJSON
class user:NSObject{
    var type_join_google:String = "g"
    
    var user_key: NSString?
    var sns_key:String?
    var type:String?
    var img: String?
    var name: String?
    var gender: String?//M, F

    /*
    init(user_key: String?, sns_key:String?, type:String?,img:String?, name:String?, gender:String){
        self.user_key = user_key
        self.sns_key = sns_key
        self.type = type
        self.img = img
        self.name = name
        self.gender = gender
    }
    */
    
    class func build(json:JSON) -> user?
    {
        let pInfo:user = user();
        pInfo.user_key = json["user_key"].stringValue as NSString
        return pInfo
    }
}
