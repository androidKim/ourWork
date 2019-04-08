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

    @IBOutlet weak var tf_WorkName: UITextField!
    @IBOutlet weak var tf_WorkDesc: UITextField!
    /**************** system fucntion ****************/
    //----------------------------------------------
    //
    override func viewDidLoad() {
        print("tabAddWorkViewController viewDidLoad")
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
    //
    func initLayout(){
        
    }
    //----------------------------------------------
    //keyboard hide
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

