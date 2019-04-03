//
//  work.swift
//  ourWork
//
//  Created by taejun on 2019. 4. 4..
//  Copyright © 2019년 midasgo. All rights reserved.
//

import Foundation
import SwiftyJSON
class work:NSObject{
    var work_key:String  = "";//시퀀스
    var name: String = "";//집안일 명
    var desc:String="";//집안일 설명
    var work_date:String = "";//yyyyMMdd
    var work_time:String = "";//HH  0~24시
    var loop_status:String = "";//반복유무 YN
    var reg_date:String = "";//timestamp
    

    init(work_key: String?, name:String?, work_date:String?,work_time:String?, loop_status:String?, reg_date:String?){
        self.work_key = work_key!;
        self.name = name!;
        
        self.work_date = work_date!;
        self.work_time = work_time!;
        self.loop_status = loop_status!;
        self.reg_date = reg_date!;
    }
    
    class func build(json:JSON) -> work?
    {
        let pInfo:work = work(work_key: "", name:"", work_date:"",work_time:"", loop_status:"", reg_date:"");
        pInfo.work_key = json["work_key"].stringValue
        pInfo.name = json["name"].stringValue
        pInfo.work_date = json["work_date"].stringValue
        pInfo.work_time = json["work_time"].stringValue
        pInfo.loop_status = json["loop_status"].stringValue
        pInfo.reg_date = json["reg_date"].stringValue
        return pInfo
    }
}
