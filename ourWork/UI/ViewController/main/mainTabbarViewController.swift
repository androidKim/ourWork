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

/**************** extention function ****************/
//----------------------------------------------
//키보드 툴바(공용)
extension UIViewController: UITextFieldDelegate{
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action:#selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        view.endEditing(true)
    }
    @objc func cancelPressed(){
        view.endEditing(true)
    }
}
/*
 메인 탭바컨트롤러
 */
class mainTabbarViewController:UITabBarController, UITabBarControllerDelegate{
    //tab index enum
    enum tabIndex:Int {
        case tab_0 = 0//집안일 리스트 탭
        case tab_1 = 1//집안일 등록 탭
        case tab_2 = 2//가족 탭
        case tab_3 = 3//설정 탭
    }
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
        //유저테이블조회
        self.ref.child("tb_user").queryOrdered(byChild: "sns_key").queryEqual(toValue: sns_key)
        .observeSingleEvent(of: .value, with: { (snapshot) in
            //sns_key같은 값이 있으면..update
            if(snapshot.exists())
            {
                let value = snapshot.value as? NSDictionary
                let keys = value?.allKeys as! [String]
                let myKey:String = keys[0]//나의 유저키 획득
                let myInfoDic = value?[myKey] as? NSDictionary//유저키를 활용해 상세 정보 획득
                user_key = myInfoDic?["user_key"] as! String
                self.ref = self.ref.child("tb_user").child(user_key)
                let data:[String:Any] = [
                    "type":type,
                    "user_key": user_key,
                    "sns_key": sns_key,
                    "name":name,
                    "reg_date":ServerValue.timestamp()
                ]
                self.ref.setValue(data)//Set Firebase DB Row
                defaults.set(user_key, forKey: "user_key")//save userDefaults userkey
            }
            else//없으면 신규생성!
            {
                user_key = self.ref.child("tb_user").childByAutoId().key as! String//고유키
                self.ref = self.ref.child("tb_user").child(user_key)
                let data:[String:Any] = [
                    "type":type,
                    "user_key": user_key,
                    "sns_key": sns_key,
                    "name":name,
                    "reg_date":ServerValue.timestamp()
                ]
                self.ref.setValue(data)//Set Firebase DB Row
                defaults.set(user_key, forKey: "user_key")//save userDefaults userkey
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
