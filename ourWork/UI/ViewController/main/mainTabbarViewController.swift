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

class mainTabbarViewControlelr:UITabBarController, UITabBarControllerDelegate{
    /*********** member ***********/
    var tabWorkList:tabWorkListViewController!
    var tabAddWork:tabAddWorkViewController!
    var tabPeople:tabPeopleViewController!
    
    /*********** system function ***********/
    //--------------------------------------
    //
    override func viewDidLoad() {
        print("mainTabbarViewControlelr viewDidLoad")
        self.tabWorkList = tabWorkListViewController()
        self.tabPeople = tabPeopleViewController()
        self.tabAddWork = tabAddWorkViewController()
        self.delegate = self
    }
    //--------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
       print("mainTabbarViewControlelr viewWillAppear")
    }
    //--------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
          print("mainTabbarViewControlelr viewWillDisappear")
    }
    /*********** user function ***********/
}
