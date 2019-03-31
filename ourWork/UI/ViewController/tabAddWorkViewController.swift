//
//  tabAddWorkViewController.swift
//  ourWork
//
//  Created by taejun on 31/03/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//
import UIKit

/*
 할일 등록
 알림받을 대상자 등록
 */
class tabAddWorkViewController:UIViewController{
    /**************** segmentedControl ****************/
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            NSLog("click 0")
        case 1:
            NSLog("click 1")
        default:
            break;
        }
    }
    
    /**************** system fucntion ****************/
    //----------------------------------------------
    //
    override func viewDidLoad() {
        print("tabAddWorkViewController viewDidLoad")
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
}

