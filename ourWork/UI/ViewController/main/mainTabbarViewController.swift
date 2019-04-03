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
import Firebase
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
        
        let defaults = UserDefaults.standard
        if let user_key = defaults.string(forKey: "user_key"){
            //firebasedb에 저장한 userkey가 없으면..!
            if(user_key.elementsEqual("")){
                self.setUserDataProc()
            }
        }else {
            self.setUserDataProc()//최초저장
        }
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
        name = defaults.string(forKey: "name")!
        
        //firebase database에 저장..!
        var swiftyJsonVar:JSON = ["type": type, "sns_key": sns_key, "user_key": user_key, "name":name]
        //let swiftyJsonVar = JSON(jsonObj)
        var pInfo:user = user.build(json: swiftyJsonVar)!
     
        //convert the JSON to a raw String
        if let strJson = swiftyJsonVar.rawString() {
            // 'strJson' contains string version of 'jsonObject'
        
        }
        
        user_key = ref.child("tb_user").childByAutoId().key as! String//고유키
        ref = ref.child("tb_user").child(user_key)
        let data:[String:Any] = [
            "type":type,
            "user_key": user_key,
            "sns_type": sns_key,
            "name":name,
            "reg_date":ServerValue.timestamp()
        ]
        ref.setValue(data)//Set Firebase DB Row
        defaults.set(user_key, forKey: "user_key")//save userDefaults userkey
    }
}
