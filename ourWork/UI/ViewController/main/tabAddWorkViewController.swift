//
//  tabAddWorkViewController.swift
//  ourWork
//
//  Created by taejun on 31/03/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//
import UIKit

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
    var m_strDayWeek:String!//선택된 날짜로 구한 요일 값 MON, THU, WED, THUR, FRI, SAT, SUN
    var m_strRepeatYear:String = "N"//매년반복
    var m_strRepeatMonth:String = "N"//매달반복
    var m_strRepeatWeek:String = "N"//매주반복
    var m_strRepeatDay:String = "N"//매일반복
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
        //keyboard..
        addToolBar(textField: self.tf_WorkName)
        addToolBar(textField: self.tf_WorkDesc)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        //
        initLayout()
    }
    //----------------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
        print("tabAddWorkViewController viewWillAppear")
    }
    //----------------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
        print("tabAddWorkViewController viewWillDisappear")
    }
    /**************** user fucntion ****************/
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
            //Parameter..
            //get 선택된 날짜선택, 요일(yyyyMMdd HH:mm:ss, dayOfWeek)
            let selectDate = mDatePicker.date
            let nsFormat = DateFormatter()
            nsFormat.dateFormat = "yyyyMMdd"
            print(nsFormat.string(from: selectDate))
            
            //요일 구하기
            m_strDayWeek = mAppDelegate.getDayOfWeek(date: selectDate)
            
            //firebase db에 저장!
        }
        else
        {
            
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

