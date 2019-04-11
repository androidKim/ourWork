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
    var mDbRef: DatabaseReference!//firebase database
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
        self.mDbRef = Database.database().reference()//get database reference..
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
                let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : nil )
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.mDbRef.child("tb_user").queryOrdered(byChild: "user_key").queryEqual(toValue: strInputKey)
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
                                let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : nil )
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                //가족없음, 가족등록 진행
                                
                                //tb_family생성,  이미 있다면 family_key를 찾아서 해당 유저 추가!
                            }
                        }
                        else//없는 키값일떄
                        {
                            var title:String = NSLocalizedString("noti", comment: "")
                            var msg:String = NSLocalizedString("msg_not_exist_user", comment: "")
                            var ok:String = NSLocalizedString("ok", comment: "")
                            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : nil )
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                        // ...
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
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : nil )
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
}
