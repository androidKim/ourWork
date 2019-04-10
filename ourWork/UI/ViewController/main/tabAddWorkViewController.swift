//
//  tabAddWorkViewController.swift
//  ourWork
//
//  Created by taejun on 31/03/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON
/*
 집안일등록
 */


/**************** extention function ****************/
//----------------------------------------------
//키보드 툴바
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

class tabAddWorkViewController:UIViewController{
    
    /**************** defeine ****************/
    
    /**************** member ****************/
    var mAppDelegate: AppDelegate!//앱딜리게이트
    var ref: DatabaseReference!//firebase database
    var m_strDayWeek:String!//선택된 날짜로 구한 요일 값 MON, THU, WED, THUR, FRI, SAT, SUN
    var m_strRepeatYear:String = "N"//매년반복
    var m_strRepeatMonth:String = "N"//매달반복
    var m_strRepeatWeek:String = "N"//매주반복
    var m_strRepeatDay:String = "N"//매일반복
    var m_bFamilyStatus:Bool = false//가족설정여부(1인1가족 2인이상)
    /**************** controller ****************/
    @IBOutlet weak var m_lbDayWeek: UILabel!
    @IBOutlet weak var mBarButtonRight: UIBarButtonItem!//등록버튼
    @IBOutlet weak var tf_WorkName: UITextField!//집안일 이름
    @IBOutlet weak var tf_WorkDesc: UITextField!//집안일 설명
    @IBOutlet weak var mDatePicker: UIDatePicker!//날짜선택
    @IBOutlet weak var mSwitchYear: UISwitch!//매년반복설정
    @IBOutlet weak var mSwitchMonth: UISwitch!//매달반복설정
    @IBOutlet weak var mSwitchWeek: UISwitch!//매주반복설정
    @IBOutlet weak var mSwitchDay: UISwitch!//매일반복설정
    /**************** system fucntion ****************/
    //----------------------------------------------
    //
    override func viewDidLoad() {
        print("tabAddWorkViewController viewDidLoad")
        mAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ref = Database.database().reference()//get database reference..
        //keyboard..
        addToolBar(textField: self.tf_WorkName)
        addToolBar(textField: self.tf_WorkDesc)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        //
        self.initLayout()
    }
    //----------------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
        print("tabAddWorkViewController viewWillAppear")
        if(m_bFamilyStatus == false)//설정된가족이 없을떄 동작
        {
            self.checkFamilyProc()
        }
    }
    //----------------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
        print("tabAddWorkViewController viewWillDisappear")
    }
    /**************** user fucntion ****************/
    //----------------------------------------------
    //
    func initValue(){
        tf_WorkName.text = ""
        tf_WorkDesc.text = ""
    }
    //----------------------------------------------
    //초기 레이아웃
    func initLayout(){
        mBarButtonRight.action = #selector(onClickRightBtn(sender:))//등록 버튼이벤트 연결
        mDatePicker.addTarget(self, action: #selector(onPickerChanged), for:.valueChanged)//날짜피커 이벤트 연결
        //매년반복 스위치이벤트
        mSwitchYear.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        //매달반복 스위치이벤트
        mSwitchMonth.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        //매주반복 스위치이벤트
        mSwitchWeek.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        //매일반복 스위치이벤트
        mSwitchDay.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
    }
    //----------------------------------------------
    //해당 유저의 가족설정여부 확인, 가족설정 전까지는 집안일을 등록할 수 없음!
    func checkFamilyProc(){
        //가족존재여부
        let defaults = UserDefaults.standard
        if let user_key = defaults.string(forKey: "user_key"){
            //유저키 존재
            if(!user_key.elementsEqual("")){
                var dbQuery:DatabaseQuery = self.ref.child("tb_user").child(user_key)
                dbQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists())//
                    {
                        let value = snapshot.value as? NSDictionary
                        if value?["family_key"] != nil{//가족시퀀스가 존재하면
                            let family_key = value?["family_key"] as! String
                            if(!family_key.elementsEqual(""))
                            {
                                self.notExistFamily()
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
                    //
                    /*
                 
                    var title:String = NSLocalizedString("fail", comment: "")
                    var msg:String = NSLocalizedString("msg_add_work_fail", comment: "")
                    var ok:String = NSLocalizedString("ok", comment: "")
                    var cancel:String = ""
                    self.mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
                    */
                }
            }
        }
        else
        {
            self.notExistFamily()
        }
    }
    //----------------------------------------------
    //설정된 가족이 없을때
    func notExistFamily(){
        self.m_bFamilyStatus = false
        var title:String = NSLocalizedString("noti", comment: "")
        var msg:String = NSLocalizedString("msg_plz_add_family", comment: "")
        var ok:String = NSLocalizedString("yes", comment: "")
        
        //alert dialog
        let alert = UIAlertController(title: title, message: msg, preferredStyle:UIAlertControllerStyle.alert)
        //Yes
        let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : { action in
            //가족 탭으로 전환!
            self.mAppDelegate.tabBarChange(index: mainTabbarViewController.tabIndex.tab_2.rawValue)
            
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)//Show Alert!
    }
    
    //----------------------------------------------
    //
    func checkValidation() -> Bool {
        var bResult:Bool = false
        var strTitle:String = tf_WorkName.text as! String//집안일 이름
        var strDesc:String = tf_WorkDesc.text as! String//집안일 설명
        //필수..
        if(strTitle.elementsEqual(""))//집안일 명
        {
            var title:String = NSLocalizedString("msg_input_work_title", comment: "")
            var msg:String = NSLocalizedString("msg_input_work_title_sub", comment: "")
            var ok:String = NSLocalizedString("ok", comment: "")
            var cancel:String = ""
            mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
            bResult=false
        }
        else if(strDesc.elementsEqual(""))//집안일 상세내용
        {
            var title:String = NSLocalizedString("msg_input_work_desc", comment: "")
            var msg:String = NSLocalizedString("msg_input_work_desc_sub", comment: "")
            var ok:String = NSLocalizedString("ok", comment: "")
            var cancel:String = ""
            mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
            bResult=false
        }
        else
        {
            bResult = true
        }
        return bResult
    }
    
    /**************** listener ****************/
    //----------------------------------------------
    //
    @objc func onClickRightBtn(sender: UIBarButtonItem) {
        if(checkValidation())
        {
            var title:String = NSLocalizedString("add", comment: "")
            var msg:String = NSLocalizedString("msg_add_question", comment: "")
            var ok:String = NSLocalizedString("yes", comment: "")
            var cancel:String = NSLocalizedString("no", comment: "")
            
            //alert dialog등록하시겠습니까??
            let alert = UIAlertController(title: title, message: msg, preferredStyle:UIAlertControllerStyle.alert)
            //Yes
            let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.default,handler : { action in
                self.setWorkProc()
            })
            alert.addAction(okAction)
            //No
            let cancelAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel,handler : { action in
                self.dismiss(animated: true, completion: nil)//dismiss alert
                self.initValue()//텍스트필드에 입력된 값 초기화
            })
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)//Show Alert!
        }
        else//집안일 등록시 필수 입력값이 누락
        {
            
        }
    }
    //----------------------------------------------
    //firebase database에등록
    func setWorkProc(){
        //Parameter..
        //get 선택된 날짜선택, 요일(yyyyMMdd HH:mm:ss, dayOfWeek)
        let selectDate = mDatePicker.date
        let nsFormat = DateFormatter()
        nsFormat.dateFormat = "yyyyMMdd"
        print(nsFormat.string(from: selectDate))
        
        //요일 구하기
        m_strDayWeek = mAppDelegate.getDayOfWeek(yyyyMMdd: selectDate)
        
        //등록일
        let date = Date()
        let regDate = nsFormat.string(from: date)//yyyyMMdd
        
        //work객체  json
        var swiftyJsonVar:JSON = ["work_key": "",
                                  "title": tf_WorkName.text as! String,
                                  "desc": tf_WorkDesc.text as! String,
                                  "work_date":nsFormat.string(from: selectDate),
                                  "day_week": m_strDayWeek,
                                  "repeat_year": m_strRepeatYear,
                                  "repeat_month": m_strRepeatMonth,
                                  "repeat_week": m_strRepeatWeek,
                                  "repeat_day": m_strRepeatDay,
                                  "reg_date": regDate]
        
        //
        var pInfo:work = work.build(json: swiftyJsonVar)!
        
        //convert the JSON to a raw String
        if let strJson = swiftyJsonVar.rawString() {
            // 'strJson' contains string version of 'jsonObject'
            
        }
        
        var work_key:String = ref.child("tb_work").childByAutoId().key as! String//고유키
        ref = ref.child("tb_work").child(work_key)
        let data:[String:Any] = [
            "work_key": work_key,
            "title": tf_WorkName.text as! String,
            "desc": tf_WorkDesc.text as! String,
            "work_date":nsFormat.string(from: selectDate),
            "day_week": m_strDayWeek,
            "repeat_year": m_strRepeatYear,
            "repeat_month": m_strRepeatMonth,
            "repeat_week": m_strRepeatWeek,
            "repeat_day": m_strRepeatDay,
            "reg_date":ServerValue.timestamp()
        ]
        ref.setValue(data)//Set Firebase DB Row
        //콜백리스너..  observeSingleEvent(1회동작하고 끝)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists())//정상적으로 등록!
            {
                var title:String = NSLocalizedString("complete", comment: "")
                var msg:String = NSLocalizedString("msg_add_work_complete", comment: "")
                var ok:String = NSLocalizedString("ok", comment: "")
                var cancel:String = ""
                self.mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
                
                self.initValue()//
            }
            else//등록 실패!
            {
                var title:String = NSLocalizedString("fail", comment: "")
                var msg:String = NSLocalizedString("msg_add_work_fail", comment: "")
                var ok:String = NSLocalizedString("ok", comment: "")
                var cancel:String = ""
                self.mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
            }
        }) { (error) in
            //
            print(error.localizedDescription)
            var title:String = NSLocalizedString("fail", comment: "")
            var msg:String = NSLocalizedString("msg_add_work_fail", comment: "")
            var ok:String = NSLocalizedString("ok", comment: "")
            var cancel:String = ""
            self.mAppDelegate.showAlert(title: title, msg: msg, ok: ok, cancel: cancel)
        }
    }
    //----------------------------------------------
    //날짜피커에서 얻은 날짜 값..
    @objc func onPickerChanged(){
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .full
        let date = dateformatter.string(from: mDatePicker.date)
        print("datePicker Value : " + date)
    }
    //----------------------------------------------
    //매년반복 스위치 on/off
    @objc
    func switchChanged(mySwitch: UISwitch) {
        //매년반복
        if(mySwitch == mSwitchYear)
        {
            if mSwitchYear.isOn {
                m_strRepeatYear = "Y"
            } else {
                m_strRepeatYear = "N"
            }
        }
        else if(mySwitch == mSwitchMonth)
        {
            //매달반복
            if mSwitchMonth.isOn {
                m_strRepeatMonth = "Y"
            } else {
                m_strRepeatMonth = "N"
            }
        }
        else if(mySwitch == mSwitchWeek)
        {
            //매주반복
            if mSwitchWeek.isOn {
                m_strRepeatWeek = "Y"
            } else {
                m_strRepeatWeek = "N"
            }
        }
        else if(mySwitch == mSwitchDay)
        {
            //매일반복
            if mSwitchDay.isOn {
                m_strRepeatDay = "Y"
            } else {
                m_strRepeatDay = "N"
            }
        }
        else
        {
            
        }
    }
    //----------------------------------------------
    //keyboard hide
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

