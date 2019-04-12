//
//  addPersonViewController.swift
//  ourWork
//
//  Created by taejun on 2019. 3. 31..
//  Copyright © 2019년 midasgo. All rights reserved.
//

/*
 가족등록 뷰컨트롤러
 */
import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON


/**************** extention function ****************/
class addFamilyViewController:UIViewController{
    /************* Member *************/
    var mAppDelegate: AppDelegate!//앱딜리게이트
    /************* controller *************/
    @IBOutlet weak var m_RightBarButton: UIBarButtonItem!
    @IBOutlet weak var m_LeftBarButton: UIBarButtonItem!
    @IBOutlet weak var m_lbDesc: UILabel!
    @IBOutlet weak var m_tfCopyUserKey: UITextField!
    /************* system function *************/
    //------------------------------------------
    //
    override func viewDidLoad() {
        self.mAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.initLayout()
    }
    //------------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {

    }
    //------------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {

    }
    /************* user function *************/
    //------------------------------------------
    //
    func initLayout() {
        self.m_lbDesc.text = NSLocalizedString("add_user_key_desc", comment: "")
        
        //이벤트 연결..
        addToolBar(textField: self.m_tfCopyUserKey)
        self.m_LeftBarButton.action = #selector(onClickLeftBtn(sender:))//뒤로가기 버튼 이벤트 연결
        self.m_RightBarButton.action = #selector(onClickRightBtn(sender:))//가족등록 버튼이벤트 연결
    }
    
    /************* listener *************/
    //----------------------------------------------
    //뒤로가기버튼
    @objc func onClickLeftBtn(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    //----------------------------------------------
    //가족등록버튼
    @objc func onClickRightBtn(sender: UIBarButtonItem) {
        
        var strInputKey:String = m_tfCopyUserKey.text as! String
        if(!strInputKey.elementsEqual(""))//가족등록할 사람 키 입력 여부..
        {
            let defaults = UserDefaults.standard
            let user_key:String = defaults.string(forKey: "user_key") as! String//나의 키 값
            if(user_key.elementsEqual(strInputKey))
            {
                //나를 가족으로 등록할수는 없음..!
                var title:String = NSLocalizedString("noti", comment: "")
                var msg:String = NSLocalizedString("msg_its_my_key", comment: "")
                var ok:String = NSLocalizedString("ok", comment: "")
                self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
            }
            else
            {
                //나의 가족키 존재여부 검사
                var dbRef = Database.database().reference()
                dbRef.child("tb_user").queryOrdered(byChild: "user_key").queryEqual(toValue: user_key)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        //해당유저객체 존재..
                        if(snapshot.exists())
                        {
                            //family_key존재 여부로 가족설정여부 판단..
                            let value = snapshot.value as? NSDictionary
                            let keys = value?.allKeys as! [String]
                            let myKey:String = keys[0]//나의 유저키 획득
                            let myInfoDic = value?[myKey] as? NSDictionary//유저키를 활용해 상세 정보 획득
                            
                            if ((myInfoDic?["family_key"]) != nil)//나의 가족키 존재
                            {
                                var family_key:String = myInfoDic?["family_key"] as! String
                                self.updateFamilyProc(family_key:family_key, strInputKey: strInputKey)//기존가족 그룹에 타켓 업데이트
                            }
                            else
                            {
                                self.createNewFailyProc(user_key:user_key, strInputKey: strInputKey)//새로운 가족 생성
                            }
                        }
                        else
                        {
                            
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                }
                
                
            }
        }
        else//입력이 되지 않았음
        {
            var title:String = NSLocalizedString("noti", comment: "")
            var msg:String = NSLocalizedString("msg_not_input_key", comment: "")
            var ok:String = NSLocalizedString("ok", comment: "")
            showAlert(title: title, msg: msg, ok: ok, cancel: "")
        }
    }
    //----------------------------------------------
    //기존가족에  업데이트
    func updateFamilyProc(family_key:String, strInputKey:String){
        //
        var dbRef = Database.database().reference()
        dbRef.child("tb_user").queryOrdered(byChild: "user_key").queryEqual(toValue: strInputKey)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                //해당유저객체 존재..
                if(snapshot.exists())
                {
                    //타겟의  family_key존재 여부로 가족설정여부 판단..
                    let value = snapshot.value as? NSDictionary
                    let keys = value?.allKeys as! [String]
                    let myKey:String = keys[0]//나의 유저키 획득
                    let myInfoDic = value?[myKey] as? NSDictionary//유저키를 활용해 상세 정보 획득
                    if ((myInfoDic?["family_key"]) != nil)
                    {
                        //이미가족있음
                        var title:String = NSLocalizedString("noti", comment: "")
                        var msg:String = NSLocalizedString("msg_this_user_exist_family", comment: "")
                        var ok:String = NSLocalizedString("ok", comment: "")
                        self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                    }
                    else
                    {
                        //가족없음, 나의 가족에 포함시키기 진행..
                        dbRef = Database.database().reference()
                        dbRef = dbRef.child("tb_family").child(family_key)

                        //콜백리스너..  observeSingleEvent(1회동작하고 끝)
                        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if(snapshot.exists())//정상적으로 등록!
                            {
                                //존재하던 가족 데이터 에 타겟 키 추가
                                let value = snapshot.value as? NSDictionary
                                var member_list:Array = [String]()
                                member_list = value?["member_list"] as! Array
                                member_list.append(strInputKey)//타켓키
                                let data:[String:Any] = [
                                    "member_list":member_list
                                ]
                                dbRef.updateChildValues(data)//타겟키만 member_lsit에 추가
                                
                                //가족설정완료되었습니다 팝업 후 유저정보에.가족 키 설정
                                var title:String = NSLocalizedString("noti", comment: "")
                                var msg:String = NSLocalizedString("msg_family_setting_complete", comment: "")
                                var ok:String = NSLocalizedString("ok", comment: "")
                                self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                                self.m_tfCopyUserKey.text = ""//텍스트필드UI 초기화
                                //member_list의 user정보도 familkey update!
                                var length:Int = member_list.count - 1;
                                for i in 0...length {
                                    var user_key:String = member_list[i]
                                    self.userFamilyKeyUpdateProc(user_key: user_key, family_key: family_key)
                                }
                            }
                            else//등록 실패!
                            {
                                var title:String = NSLocalizedString("fail", comment: "")
                                var msg:String = NSLocalizedString("msg_family_setting_fail", comment: "")
                                var ok:String = NSLocalizedString("ok", comment: "")
                                self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                            }
                        }) { (error) in
                            //
                            print(error.localizedDescription)
                            var title:String = NSLocalizedString("fail", comment: "")
                            var msg:String = NSLocalizedString("msg_add_work_fail", comment: "")
                            var ok:String = NSLocalizedString("ok", comment: "")
                            self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                        }
                    }
                }
                else//없는 키값일떄
                {
                    var title:String = NSLocalizedString("noti", comment: "")
                    var msg:String = NSLocalizedString("msg_not_exist_user", comment: "")
                    var ok:String = NSLocalizedString("ok", comment: "")
                    self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    //----------------------------------------------
    //새로운가족생성 및 유저정보의 패밀리키 업데이트
    func createNewFailyProc(user_key:String, strInputKey:String){
        var dbRef = Database.database().reference()
        dbRef.child("tb_user").queryOrdered(byChild: "user_key").queryEqual(toValue: strInputKey)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                //해당유저객체 존재..
                if(snapshot.exists())
                {
                    //family_key존재 여부로 가족설정여부 판단..
                    let value = snapshot.value as? NSDictionary
                    let keys = value?.allKeys as! [String]
                    let myKey:String = keys[0]//나의 유저키 획득
                    let myInfoDic = value?[myKey] as? NSDictionary//유저키를 활용해 상세 정보 획득
                    if ((myInfoDic?["family_key"]) != nil)
                    {
                        //이미가족있음
                        var title:String = NSLocalizedString("noti", comment: "")
                        var msg:String = NSLocalizedString("msg_this_user_exist_family", comment: "")
                        var ok:String = NSLocalizedString("ok", comment: "")
                        self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                    }
                    else
                    {
                        //가족없음, 가족등록 진행
                        var family_key:String = dbRef.child("tb_family").childByAutoId().key as! String//고유키
                        var member_list:Array = [String]()//memberlist
                        member_list.append(user_key)//나의키
                        member_list.append(strInputKey)//타켓키
                        dbRef = Database.database().reference()
                        dbRef = dbRef.child("tb_family").child(family_key)
                        let data:[String:Any] = [
                            "family_key": family_key,
                            "reg_date":ServerValue.timestamp(),
                            "member_list":member_list
                        ]
                        dbRef.setValue(data)//Set Firebase DB Row
                        //콜백리스너..  observeSingleEvent(1회동작하고 끝)
                        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if(snapshot.exists())//정상적으로 등록!
                            {
                                var title:String = NSLocalizedString("noti", comment: "")
                                var msg:String = NSLocalizedString("msg_family_setting_complete", comment: "")
                                var ok:String = NSLocalizedString("ok", comment: "")
                                self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                                self.m_tfCopyUserKey.text = ""//텍스트필드UI 초기화
                                //member_list의 user정보도 familkey update!
                                var length:Int = member_list.count - 1;
                                for i in 0...length {
                                    var user_key:String = member_list[i]
                                    self.userFamilyKeyUpdateProc(user_key: user_key, family_key: family_key)
                                }
                            }
                            else//등록 실패!
                            {
                                var title:String = NSLocalizedString("fail", comment: "")
                                var msg:String = NSLocalizedString("msg_family_setting_fail", comment: "")
                                var ok:String = NSLocalizedString("ok", comment: "")
                                self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                            }
                        }) { (error) in
                            //
                            print(error.localizedDescription)
                            var title:String = NSLocalizedString("fail", comment: "")
                            var msg:String = NSLocalizedString("msg_add_work_fail", comment: "")
                            var ok:String = NSLocalizedString("ok", comment: "")
                            self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                        }
                    }
                }
                else//없는 키값일떄
                {
                    var title:String = NSLocalizedString("noti", comment: "")
                    var msg:String = NSLocalizedString("msg_not_exist_user", comment: "")
                    var ok:String = NSLocalizedString("ok", comment: "")
                    self.showAlert(title: title, msg: msg, ok: ok, cancel: "")
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
    }
    //----------------------------------------------
    //
    func userFamilyKeyUpdateProc(user_key:String, family_key:String){
        //유저테이블조회
        var dbRef = Database.database().reference()
        dbRef.child("tb_user").queryOrdered(byChild: "user_key").queryEqual(toValue: user_key)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
                //user_key같은 값이 있으면..update
                if(snapshot.exists())
                {
                    let value = snapshot.value as? NSDictionary
                    let keys = value?.allKeys as! [String]
                    let myKey:String = keys[0]//나의 유저키 획득
                    let myInfoDic = value?[myKey] as? NSDictionary//유저키를 활용해 상세 정보 획득
                    dbRef = Database.database().reference()
                    dbRef = dbRef.child("tb_user").child(user_key)
                    let data:[String:Any] = [
                        "family_key": family_key,
                    ]
                    dbRef.updateChildValues(data)//유저정보에 familykey 업데이트!
                }
                else//
                {
                
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    //----------------------------------------------
    //
    func showAlert(title:String, msg:String, ok:String, cancel:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        if(!ok.elementsEqual(""))
        {
            let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : nil )
            alert.addAction(okAction)
        }
        
        if(!cancel.elementsEqual(""))
        {
            let cancelAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : nil )
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
