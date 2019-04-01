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
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var containerView: UIView!
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
        GIDSignIn.sharedInstance().signIn()
        
        self.containerView.addSubview(signInButton)
    }
    //--------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
        print("loginViewController viewWillAppear")
    }
    //--------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
        print("loginViewController viewWillDisappear")
    }
    /*********** google sign function ***********/
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        // ...
    }
    //마지막으로 Firebase 사용자 인증 정보를 사용해 Firebase에 인증합니다
    
    //google sign out
    func googleSignout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
