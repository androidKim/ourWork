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
    
    var user_key: String?
    var sns_key:String?
    var type:String?
    var img: String?
    var name: String?
    var gender: String?//M, F
    var family_key:String?//가족 시퀀스(가족은 1개만 설정가능)

    
    init(user_key: String?, sns_key:String?, type:String?,img:String?, name:String?, gender:String, family_key:String){
        self.user_key = user_key
        self.sns_key = sns_key
        self.type = type
        self.img = img
        self.name = name
        self.gender = gender
        self.family_key = family_key
    }
    
    class func build(json:JSON) -> user?
    {
        let pInfo:user = user(user_key: "",sns_key: "",type: "",img: "",name: "",gender: "", family_key: "");
        pInfo.user_key = json["user_key"].stringValue
        pInfo.sns_key = json["sns_key"].stringValue
        pInfo.type = json["type"].stringValue
        pInfo.img = json["img"].stringValue
        pInfo.name = json["name"].stringValue
        pInfo.gender = json["gender"].stringValue
        pInfo.family_key = json["family_key"].stringValue
        return pInfo
    }
}
