//
//  work.swift
//  ourWork
//
//  Created by taejun on 2019. 4. 4..
//  Copyright © 2019년 midasgo. All rights reserved.
//  집안일 모델 구조체
//

import Foundation
import SwiftyJSON
class work:NSObject{
    var work_key:String  = "";//시퀀스
    var title: String = "";//집안일 명
    var desc:String="";//집안일 설명
    var work_date:String = "";//yyyyMMdd
    var day_week:String = "";//요일(MON,TUE,WED,THUR,FRI,SAT,SUN로 표기)
    var repeat_year:String = "";//매년반복 YN(yyyMMdd에 푸시알림)
    var repeat_month:String = "";//매달반복YN (dd에 푸시알림)
    var repeat_week:String = "";//매주반복 YN(요일로 푸시알림)
    var repeat_day:String = "";//매일반복 (매일 푸시알림)
    var reg_date:String = "";//timestamp
    
    init(work_key: String?, title:String?, desc:String?, work_date:String?, day_week:String?,work_time:String?, repeat_year:String?,repeat_month:String?, repeat_week:String?, repeat_day:String?, reg_date:String?){
        self.work_key = work_key!
        self.title = title!
        self.desc = desc!
        self.work_date = work_date!//yyyyMMdd
        self.day_week = day_week!//요일
        self.repeat_year = repeat_year!//YN
        self.repeat_month = repeat_month!//YN
        self.repeat_week = repeat_week!//YN
        self.repeat_day = repeat_day!//YN
        self.reg_date = reg_date!
    }
    
    class func build(json:JSON) -> work?
    {
        let pInfo:work = work(work_key: "", title:"", desc:"",work_date:"", day_week:"",work_time:"",
                              repeat_year:"", repeat_month:"",repeat_week:"",repeat_day:"",reg_date:"");
        pInfo.work_key = json["work_key"].stringValue
        pInfo.title = json["title"].stringValue
        pInfo.work_date = json["work_date"].stringValue
        pInfo.day_week = json["day_week"].stringValue
        pInfo.repeat_year = json["repeat_year"].stringValue
        pInfo.repeat_month = json["repeat_month"].stringValue
        pInfo.repeat_week = json["repeat_week"].stringValue
        pInfo.repeat_day = json["repeat_day"].stringValue
        pInfo.reg_date = json["reg_date"].stringValue
        return pInfo
    }
}

