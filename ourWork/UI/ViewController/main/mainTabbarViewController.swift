//
//  mainTabbarViewController.swift
//  ourWork
//
//  Created by taejun on 31/03/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//

/*
 start ViewController..!
 tab1 : work list(my list , all list)
 tab2 : people list(worker)
 */
import Foundation
import UIKit
import FirebaseDatabase
import SwiftyJSON

class mainTabbarViewController:UITabBarController, UITabBarControllerDelegate{
    /*********** member ***********/
    var tabWorkList:tabWorkListViewController!
    var tabAddWork:tabAddWorkViewController!
    var tabPeople:tabPeopleViewController!
    var ref: DatabaseReference!//firebase database
    /*********** system function ***********/
    //--------------------------------------
    //
    override func viewDidLoad() {
        print("mainTabbarViewController viewDidLoad")
        self.tabWorkList = tabWorkListViewController()
        self.tabPeople = tabPeopleViewController()
        self.tabAddWork = tabAddWorkViewController()
        self.delegate = self
        
        self.ref = Database.database().reference()//get database reference..
        self.setUserDataProc()
    }
    //--------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
       print("mainTabbarViewController viewWillAppear")
    }
    //--------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
          print("mainTabbarViewController viewWillDisappear")
    }
    /*********** user function ***********/
    //--------------------------------------
    //
    func setUserDataProc(){
        //login하면서 저장한 앱내 유저정보..
        let defaults = UserDefaults.standard
        var user_key:String = ""
        var sns_key:String = ""
        var type:String = ""
        var img:String = ""
        var name:String = ""
        var gender:String = ""
        type = defaults.string(forKey: "type")!
        sns_key = defaults.string(forKey: "sns_key")!
        user_key = defaults.string(forKey: "user_key")!
        name = defaults.string(forKey: "name")!
        
        //firebase database에 저장..!
        //var pUser:user = user(user_key:user_key, sns_key:sns_key , type:type, img:"", name:name, gender: "")
        
        /*
        let swiftyJsonVar:JSON = "["user_key":'aa']"
        var pInfo:user = user.build(json: swiftyJsonVar)!
        self.ref.child("tb_user").setValue(swiftyJsonVar)
         */
    }
}
