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

class mainTabbarViewController:UITabBarController, UITabBarControllerDelegate{
    /*********** member ***********/
    var tabWorkList:tabWorkListViewController!
    var tabAddWork:tabAddWorkViewController!
    var tabPeople:tabPeopleViewController!
    
    /*********** system function ***********/
    //--------------------------------------
    //
    override func viewDidLoad() {
        print("mainTabbarViewController viewDidLoad")
        self.tabWorkList = tabWorkListViewController()
        self.tabPeople = tabPeopleViewController()
        self.tabAddWork = tabAddWorkViewController()
        self.delegate = self
        
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
        if let type = defaults.string(forKey: "type") {
            print(type) // Some String Value
        }
        
        if let sns_key = defaults.string(forKey: "sns_key") {
            print(sns_key) // Some String Value
        }
        
        if let user_key = defaults.string(forKey: "user_key") {
            print(user_key) // Some String Value
        }
        
        if let name = defaults.string(forKey: "name") {
            print(name) // Some String Value
        }
        
        
        //firebase database에 저장..!
        
        
    }
}
