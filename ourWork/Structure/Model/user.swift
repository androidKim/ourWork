//
//  user.swift
//  ourWork
//
//  Created by taejun on 01/04/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//

class user{
    var user_key: String?
    var img: String?
    var name: String?
    var gender: String?//M, F

    init(user_key: String?, img:String?, name:String?, gender:String){
        self.user_key = user_key;
        self.img = img;
        self.name = name;
        self.gender = gender;
    }
}
