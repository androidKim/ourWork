//
//  loginViewController.swift
//  ourWork
//
//  Created by taejun on 2019. 4. 1..
//  Copyright © 2019년 midasgo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class loginViewController:UIViewController, GIDSignInUIDelegate{
    /*********** member ***********/
    
    /*********** coltroller ***********/
    var btn_GoogleSign: GIDSignInButton!
    @IBOutlet weak var v_Contaier: UIView!
    //--------------------------------------
    //sign out
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    /*********** system function ***********/
    //--------------------------------------
    //
    override func viewDidLoad() {
        print("loginViewController viewDidLoad")
        
        GIDSignIn.sharedInstance().uiDelegate = self
        self.addViewGoogleLoginBtn()
    }
    //--------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
        print("loginViewController viewWillAppear")
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if((appDelegate?.isLogin())!)
        {
            appDelegate?.goMain();
            return
        }
    }
    //--------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
        print("loginViewController viewWillDisappear")
    }
    /*********** google sign function ***********/
    //--------------------------------------
    //addview google login button
    func addViewGoogleLoginBtn(){
        self.btn_GoogleSign = GIDSignInButton()
        self.btn_GoogleSign.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: 48)
        self.v_Contaier.addSubview(btn_GoogleSign)   
    }
    
    /*
    func googleLoginAction(){
        //GIDSignIn.sharedInstance().signIn()//로그인시도
    }
    
    func googleLogoutAction(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
     */
}
