//
//  tabWorkerList.swift
//  ourWork
//
//  Created by taejun on 2019. 3. 31..
//  Copyright © 2019년 midasgo. All rights reserved.
//
/*
 tab2 : 가족등록 탭
*/
import Foundation
import Firebase
import FirebaseDatabase
import SwiftyJSON
import UIKit
class tabPeopleViewController:UIViewController{
    /**************** member ****************/
    var mAppDelegate: AppDelegate!//앱딜리게이트
    var mDbRef: DatabaseReference!//firebase database
    var m_bFamilyExist:Bool = false
    
    /**************** Controller ****************/
    @IBOutlet weak var m_RightBarButton: UIBarButtonItem!//가족등록화면으로 이동
    @IBOutlet weak var m_TableView: UITableView!
    /**************** system fucntion ****************/
    //----------------------------------------------
    //
    override func viewDidLoad() {
        print("tabPeopleViewController viewDidLoad")
        self.mAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.mDbRef = Database.database().reference()//get database reference..
        self.initLayout()
    }
    //----------------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
        print("tabPeopleViewController viewWillAppear")
        if(!m_bFamilyExist)
        {
            checkFamilyProc()//가족설정 여부 검사
        }
    }
    //----------------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
        print("tabPeopleViewController viewWillDisappear")
    }

    /**************** user fucntion ****************/
    //----------------------------------------------
    //레이아웃 초기설정
    func initLayout(){
        self.m_RightBarButton.action = #selector(onClickRightBtn(sender:))//가족등록 버튼이벤트 연결
    }
    //----------------------------------------------
    //
    func checkFamilyProc(){
        let defaults = UserDefaults.standard
        if let user_key = defaults.string(forKey: "user_key"){
            //유저키 존재
            if(!user_key.elementsEqual("")){
                var dbQuery:DatabaseQuery = self.mDbRef.child("tb_user").child(user_key)
                dbQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists())//
                    {
                        let value = snapshot.value as? NSDictionary
                        if value?["family_key"] != nil{//가족시퀀스가 존재하면
                            let family_key = value?["family_key"] as! String
                            if(!family_key.elementsEqual(""))
                            {
                                self.existFamily()
                            }
                            else
                            {
                                self.notExistFamily()
                            }
                        }
                        else
                        {
                            self.notExistFamily()
                        }
                    }
                    else//
                    {
                        self.notExistFamily()
                    }
                }) { (error) in
                    print(error.localizedDescription)
                    //서버통신실패 alert
                    var title:String = NSLocalizedString("api_fail", comment: "")
                    var msg:String = NSLocalizedString("msg_api_error", comment: "")
                    var ok:String = NSLocalizedString("ok", comment: "")
                    var cancel:String = ""
                    self.mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
                }
            }
        }
        else
        {
            self.notExistFamily()
        }
    }
    //----------------------------------------------
    //
    func existFamily(){
        m_bFamilyExist = true
        self.m_TableView.isHidden = false//
    }
    
    //----------------------------------------------
    //
    func notExistFamily(){
        self.m_bFamilyExist = false
        self.m_TableView.isHidden = true//가족이 없을땐 테이블뷰 숨김
        //empty 레이아웃 노출
    }
    /**************** listener ****************/
    //----------------------------------------------
    //가족등록버튼
    @objc func onClickRightBtn(sender: UIBarButtonItem) {
        //가족등록 뷰컨트롤러 이동..
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let addFamilyViewController = storyBoard.instantiateViewController(withIdentifier: "addFamilyViewController") as! addFamilyViewController
        self.present(addFamilyViewController, animated:true, completion:nil)
    }
}
